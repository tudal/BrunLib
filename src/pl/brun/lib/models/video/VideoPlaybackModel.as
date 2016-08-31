package pl.brun.lib.models.video {
	import flash.utils.ByteArray;

	import pl.brun.lib.Base;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	[Event(name="videoStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="netStreamPlayStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="videoEnd", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="playStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="playStop", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="volumeChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="playingProgressChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="loadingProgressChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="loadFinish", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="bufferingStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="bufferingFinish", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="recivedMetaData", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="streamNotFound", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	[Event(name="cuePoint", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	/**
	 * @author Marek Brun
	 */
	public class VideoPlaybackModel extends Base {
		private var _video:Video;
		private var connection:NetConnection;
		private var isBuffering:Boolean = true;
		public var metaData:VideoMetaData;
		private var netStream:NetStream;
		private var bufferTime:Number;
		private var volume:Number = .8;
		private var isPlaying:Boolean;
		public var isStartedStream:Boolean;
		private var lastLoadingProgress:Number;
		private var isBufferFlush:Boolean;
		private var isStarted:Boolean;
		private var lastNotifyTime:int;
		private var isSeek:Boolean;
		private var nextSeek:Number;
		private var isNextSeek:Boolean;
		private var _isLoadFinished:Boolean;
		private var url:String;

		public function VideoPlaybackModel(video:Video, bufferTime:Number = 5) {
			_video = video;
			this.bufferTime = bufferTime;

			connection = new NetConnection();
			connection.connect(null);
			netStream = new NetStream(connection);
			netStream.bufferTime = 5;
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamNetStatus, false, 0, true);
			netStream.client = this;
			video.attachNetStream(netStream);
		}

		public function onXMPData(infoObject:Object):void {
		}

		private function seek(offset:Number):void {
			if(isSeek) {
				isNextSeek = true;
				nextSeek = offset;
			} else {
				netStream.seek(offset);
			}
		}

		/**
		 * Start's streaming video from passed URL. Can be called anytime, many times.
		 */
		public function startPlay(fileURL:URLRequest):void {
			_isLoadFinished = false
			dbg.log("fileURL.url:" + dbg.link(fileURL.url, true))
			netStream.play(fileURL.url);
			url=fileURL.url

			metaData = null;
			isBuffering = true;
			isBufferFlush = false;
			isStartedStream = true;

			refreshVolume();

			lastLoadingProgress = NaN;
			RootProvider.getRoot().addEventListener(Event.ENTER_FRAME, onEnterFrameWhileLoading);

			isStarted = true;

			setIsBuffering(true);
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.VIDEO_START));
			// setIsBuffering(true);
		}

		public function startPlayByteArray(ba:ByteArray):void {
			_isLoadFinished = false
			netStream.play(null)
			netStream.appendBytes(ba)

			metaData = null;
			isBuffering = true;
			isBufferFlush = false;
			isStartedStream = true;

			refreshVolume();

			lastLoadingProgress = NaN;
			RootProvider.getRoot().addEventListener(Event.ENTER_FRAME, onEnterFrameWhileLoading);

			isStarted = true;

			setIsBuffering(true);
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.VIDEO_START));
			// setIsBuffering(true);
		}

		/**
		 * Sets video volume. Volume is automatically stored in flash cookies.
		 * 
		 * @param volume - value from 0 to 1
		 */
		public function setVolume(volume:Number):void {
			if(this.volume == volume) {
				return;
			}
			this.volume = volume;
			refreshVolume();
			dispatchEvent(new Event('SharedObjectDataChanged'));
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.VOLUME_CHANGED));
		}

		/**
		 * @return current volume
		 */
		public function getVolume():Number {
			return volume;
		}

		/**
		 * Move the playhead to nearest (keyframe) passed precentage position.
		 * Method will work only after meta data is loaded. 
		 * @param n01 - number from 0 to 1, desired position
		 */
		public function setPlayingProgress(n01:Number):void {
			if(metaData && metaData.duration) {
				seek(n01 * metaData.duration);
			}
		}

		public function setPlayingProgressInTime(time:Number):void {
			setPlayingProgress(time / metaData.duration)
		}

		/**
		 * Method will work only after meta data is loaded. 
		 * @return number from 0 to 1, current precentage position of the playhead
		 */
		public function getPlayingProgress():Number {
			if(metaData) {
				return netStream.time / metaData.duration;
			}
			return NaN;
		}

		/**
		 * Method will work only after meta data is loaded. 
		 * @return number from 0 to 1, current playback precentage position
		 */
		public function getLoadingProgress():Number {
			if(isStarted) {
				return netStream.bytesLoaded / netStream.bytesTotal;
			}
			return 0;
		}
		
		/**
		 * Moves video playhead to start kayframe and stop playing.
		 */
		public function revindFlvAndStop():void {
			if(!isStartedStream) {
				return;
			}
			seek(0);
			netStream.pause();
			isPlaying = false
		}

		/**
		 * Moves video playhead to start kayframe and start playing.
		 */
		public function revindFlvAndPlay():void {
			if(!isStartedStream) {
				return;
			}
			seek(0);
			netStream.resume();
			isPlaying = true
		}

		/**
		 * @return <ul><li>true - video playing time is less than one second</li>
		 * <li>false -  video playing time is bigger than one second</li></ul>
		 */
		public function isAtStart():Boolean {
			return netStream.time < 1;
		}

		/**
		 * @return <ul><li>true - video playback is at end</li>
		 * <li>false -  video playback is not at end</li></ul>
		 */
		public function isAtEnd():Boolean {
			if(metaData) {
				return Math.round(netStream.time) == Math.round(metaData.duration);
			}
			return false;
		}

		/**
		 * @return position of the playhead, in seconds
		 */
		public function getTime():Number {
			if(!netStream || isNaN(netStream.time)) {
				return NaN;
			}
			return netStream.time;
		}

		/**
		 * @return total time of the playhead, in seconds
		 */
		public function getDuration():Number {
			if(!metaData) {
				return NaN;
			}
			return metaData.duration;
		}

		/**
		 * @return current net stream
		 */
		public function getNetStream():NetStream {
			return netStream;
		}

		/**
		 * @return <ul><li>true - video is playing (not paused)</li>
		 * <li>false -  video is paused</li></ul>
		 */
		public function getIsPlaying():Boolean {
			return isPlaying;
		}

		/**
		 * Sets video playing status. Is current playing status is same as passed status - nothing hapens.
		 * If passed value is true, and video is stopped at end video is revinded to start and played.
		 * @param playing - <ul><li>true - video is playing (not paused)</li>
		 * <li>false -  video is paused</li></ul>
		 */
		public function setIsPlaying(playing:Boolean):void {
			if(!isStartedStream) {
				return;
			}
			if(isPlaying == playing) {
				return;
			}
			isPlaying = playing;
			if(playing) {
				if(isAtEnd()) {
					revindFlvAndPlay();
				} else {
					netStream.resume();
				}
				root.addEventListener(Event.ENTER_FRAME, onEnterFrameWhilePlaying);
				dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.PLAY_START));
			} else {
				netStream.pause();
				root.removeEventListener(Event.ENTER_FRAME, onEnterFrameWhilePlaying);
				dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.PLAY_STOP));
			}
		}

		/**
		 * @return <ul><li>true - video is currently buffering (and paused)</li>
		 * <li>false -  video is currently not buffering (there's enough data in buffer)</li></ul>
		 */
		public function getIsBuffering():Boolean {
			return isBuffering;
		}

		/**
		 * @return <ul><li>true - metadata of current video is loaded and accesible</li>
		 * <li>false -  metadata of current video is not yet loaded</li></ul>
		 */
		public function gotMetaData():Boolean {
			return Boolean(metaData);
		}

		public function getMetaData():VideoMetaData {
			return metaData;
		}

		protected function refreshVolume():void {
			var videoVolumeTransform:SoundTransform = new SoundTransform();
			videoVolumeTransform.volume = volume;
			netStream.soundTransform = videoVolumeTransform;
		}

		protected function setIsBuffering(buffering:Boolean):void {
			// if(isBuffering==buffering){ return; }
			if(buffering && isBufferFlush) {
				return;
			}
			isBuffering = buffering;
			if(isBuffering) {
				dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.BUFFERING_START));
			} else {
				dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.BUFFERING_FINISH));
			}
		}

		public function close():void {
			netStream.close();
		}

		override public function dispose():void {
			netStream.close()
			_video = null;
			connection.close()
			super.dispose();
		}

		public function getSharedObjectData():Object {
			return {volume:getVolume()};
		}

		public function getSharedObjectInitData():Object {
			return {volume:0.7};
		}

		public function getSharedObjectUniqueName():String {
			return 'VideoPlayback';
		}

		public function applyCookieData(data:Object):void {
			setVolume(data.volume);
		}

		// ********************************************************************************************
		// events for VideoPlayerModel
		// ********************************************************************************************
		protected function onStreamNetStatus(event:NetStatusEvent):void {
			var infoObject:Object = event.info;
			// dbg.log('infoObject.code:' + infoObject.code);
			switch(infoObject.level) {
				case 'error':
					break;
				case 'status':
					dbg.log(infoObject.code)
					switch(infoObject.code) {
						case 'NetStream.Play.Start':
							setIsPlaying(true);
							dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.NET_STREAM_PLAY_START));
							break;
						case 'NetStream.Play.Stop':
							setIsPlaying(false);
							dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.VIDEO_END));
							break;
						case 'NetStream.Play.StreamNotFound':
							dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.STREAM_NOT_FOUND));
							break;
						case 'NetStream.Buffer.Empty':
							setIsBuffering(true);
							break;
						case 'NetStream.Buffer.Full':
							setIsBuffering(false);
							break;
						case 'NetStream.Buffer.Flush':
							isBufferFlush = true;
							setIsBuffering(false);
							break;
						case 'NetStream.Seek.Notify':
							dbg.log('NetStream.Seek.Notify')
							lastNotifyTime = getTimer();
							dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.PLAYING_PROGRESS_CHANGED));
							root.addEventListener(Event.ENTER_FRAME, onEnterFrameAfterNotify);
							FrameDelayCall.addCall(checkNextSeek, 12);
							break;
					}
					break;
			}
		}

		private function checkNextSeek():void {
			isSeek = false;
			if(isNextSeek) {
				isNextSeek = false;
				seek(nextSeek);
			}
		}

		protected function onEnterFrameWhilePlaying(event:Event):void {
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.PLAYING_PROGRESS_CHANGED));
		}

		protected function onEnterFrameAfterNotify(event:Event):void {
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.PLAYING_PROGRESS_CHANGED));
			if(getTimer() - lastNotifyTime > 1000) {
				root.removeEventListener(Event.ENTER_FRAME, onEnterFrameAfterNotify);
			}
		}

		public function onMetaData(info:Object):void {
			if(metaData) {
				return;
			}
			metaData = VideoMetaData.createByObject(info);
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.RECIVED_META_DATA));
		}

		public function onCuePoint(info:Object):void {
			// dispatchEvent(new Event(event_CuePoint, metaData.getCuePointByTime(info.time*1000)));
		}

		public function onPlayStatus(info:Object):void {
		}

		protected function onEnterFrameWhileLoading(event:Event):void {
			var loadingProgress:Number = getLoadingProgress();
			if(loadingProgress == lastLoadingProgress) {
				return;
			}
			lastLoadingProgress = getLoadingProgress();
			dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.LOADING_PROGRESS_CHANGED));
			if(lastLoadingProgress == 1) {
				root.removeEventListener(Event.ENTER_FRAME, onEnterFrameWhileLoading);
				_isLoadFinished = true
				dispatchEvent(new VideoPlaybackEvent(VideoPlaybackEvent.LOAD_FINISH));
			}
		}

		public function get video():Video {
			return _video;
		}

		public function get isLoadFinished():Boolean {
			return _isLoadFinished;
		}
	}
}
