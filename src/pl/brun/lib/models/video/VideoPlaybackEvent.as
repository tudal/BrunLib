package pl.brun.lib.models.video {
	import flash.events.Event;

	/**
	 * [Event(name="videoStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="netStreamPlayStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="videoEnd", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="playStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="playStop", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="volumeChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="playingProgressChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="loadingProgressChanged", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="loadFinish", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="bufferingStart", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="bufferingFinish", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="recivedMetaData", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="streamNotFound", type="pl.brun.lib.models.video.VideoPlaybackEvent")]	 * [Event(name="cuePoint", type="pl.brun.lib.models.video.VideoPlaybackEvent")]
	 * 
	 * @author Marek Brun
	 */
	public class VideoPlaybackEvent extends Event {

		/** New streaming is started load. Video is playing. Event just after "startPlay" method. */
		public static const VIDEO_START:String = 'videoStart';

		public static const NET_STREAM_PLAY_START:String = 'netStreamPlayStart';

		/** Video playback reached end. */
		public static const VIDEO_END:String = 'videoEnd';

		/** Playback is started (from paused). */
		public static const PLAY_START:String = 'playStart';

		/** Playback is paused. */
		public static const PLAY_STOP:String = 'playStop';

		public static const VOLUME_CHANGED:String = 'volumeChanged';

		public static const PLAYING_PROGRESS_CHANGED:String = 'playingProgressChanged';

		public static const LOADING_PROGRESS_CHANGED:String = 'loadingProgressChanged';

		public static const LOAD_FINISH:String = 'loadFinish';

		public static const BUFFERING_START:String = 'bufferingStart';

		public static const BUFFERING_FINISH:String = 'bufferingFinish';

		/** Meta data is laoded and accesible now. */
		public static const RECIVED_META_DATA:String = 'recivedMetaData';

		/** Cant find streaming from passed URL. */
		public static const STREAM_NOT_FOUND:String = 'streamNotFound';

		/**  */
		//DATA:	VideoCuePoint
		public static const CUE_POINT:String = 'cuePoint';

		public function VideoPlaybackEvent(type:String) {
			super(type);
		}
	}
}
