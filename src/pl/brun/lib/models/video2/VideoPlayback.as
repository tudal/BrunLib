package pl.brun.lib.models.video2 {
	/**
	 * @author Marek Brun
	 */
	public class VideoPlayback {
		private var main:Main;

		public function VideoPlayback(view:IVideoPlaybackView) {
			main = new Main(view)
		}

		public function startPlay(url:String, playOnStart:Boolean):void {
			main.startPlay(url, playOnStart)
		}

		public function dispose():void {
			main.dispose()
		}

		public function pause():void {
			main.pause()
		}

		public function resume():void {
			main.resume()
		}

		public function rewind():void {
			main.rewind()
		}

		public function setVolume(volume:Number):void {
			main.setVolume(volume)
		}
	}
}
import pl.brun.lib.models.video2.IVideoPlaybackView;

import flash.events.NetStatusEvent;
import flash.media.SoundTransform;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.utils.clearInterval;
import flash.utils.setInterval;

class Main {
	public var connection:NetConnection;
	public var netStream:NetStream;
	public var playOnStart:Boolean;
	public var view:IVideoPlaybackView;
	public var loadingProgress:Number = 0;
	public var metaData:Object;
	// public var dbg:DebugServiceProxy;
	public var volume:Number;
	private var state:State;
	private var intervalID:uint;

	public function Main(view:IVideoPlaybackView) {
		this.view = view
		connection = new NetConnection()
		connection.connect(null)
		netStream = new NetStream(connection)
		netStream.bufferTime = 5
		netStream.client = this
		netStream.addEventListener(NetStatusEvent.NET_STATUS, onStreamNetStatus, false, 0, true)
		view.getVideo().attachNetStream(netStream)

		// dbg = DebugServiceProxy.forInstance(this)

		setState(new NoVideoState())
		intervalID = setInterval(onInterval, 1)
	}

	public function rewind():void {
		setState(new FirstFramesState(false))
	}


	public function pause():void {
		state.pause()
	}

	public function resume():void {
		state.resume()
	}

	public function onCuePoint(cueObject:Object):void {
		// dbg.log("onCuePoint(" + dbg.linkArr(arguments, true) + ')')
	}

	public function onImageData(imageData:Object):void {
		// dbg.log("onImageData(" + dbg.linkArr(arguments, true) + ')')
	}

	public function onMetaData(item:Object):void {
		// dbg.log("onMetaData(" + dbg.linkArr(arguments, true) + ')')
		metaData = item
	}

	public function onPlayStatus(infoObject:Object):void {
		// dbg.log("onPlayStatus(" + dbg.linkArr(arguments, true) + ')')
	}

	public function onSeekPoint(seekObject:Object):void {
		// dbg.log("onSeekPoint(" + dbg.linkArr(arguments, true) + ')')
	}

	public function onTextData(textData:Object):void {
		// dbg.log("onTextData(" + dbg.linkArr(arguments, true) + ')')
	}

	private function onInterval():void {
		state.onInterval()
	}

	public function setState(state:State):void {
		if (this.state) this.state.dispose();
		this.state = state
		// dbg.log('state:<b>' + getQualifiedClassName(state) + '</b>')
		state.init(this)
		state.start()
	}

	public function startPlay(url:String, playOnStart:Boolean):void {
		netStream.play(url)
		this.playOnStart = playOnStart
		state.startPlay(url, playOnStart)
	}

	private function onStreamNetStatus(event:NetStatusEvent):void {
		if (event.info.level == 'status') {
			state.onStreamNetStatus(event.info.code)
		}
	}

	public function getLoadingProgress():Number {
		if (netStream.bytesTotal > 100) {
			return netStream.bytesLoaded / netStream.bytesTotal;
		}
		return 0
	}

	public function getPlayingProgress():Number {
		if (metaData) {
			return netStream.time / metaData.duration;
		}
		return 0;
	}

	public function setVolume(volume:Number):void {
		this.volume = volume
		setVolume2(volume)
	}

	public function setVolume2(volume:Number):void {
		var videoVolumeTransform:SoundTransform = new SoundTransform();
		videoVolumeTransform.volume = volume
		trace(volume)
		netStream.soundTransform = videoVolumeTransform
	}

	public function dispose():void {
		clearInterval(intervalID)
		state.dispose()
	}
}
class State {
	protected var m:Main;

	public function init(m:Main):void {
		this.m = m;
	}

	public function start():void {
	}

	public function startPlay(url:String, playOnStart:Boolean):void {
		m.setState(new InitLoadingState(url, playOnStart))
	}

	public function dispose():void {
	}

	public function onStreamNetStatus(code:String):void {
	}

	public function onInterval():void {
	}

	public function pause():void {
	}

	public function resume():void {
	}
}
class VideoState extends State {
	override public function onInterval():void {
		var progress:Number = m.getLoadingProgress()
		if (progress == m.loadingProgress) return;
		m.loadingProgress = progress
		m.view.setLoadingProgress(progress)
	}
}
class InitLoadingState extends VideoState {
	private var playOnStart:Boolean;
	private var url:String;

	public function InitLoadingState(url:String, playOnStart:Boolean) {
		this.url = url
		this.playOnStart = playOnStart
	}

	override public function start():void {
		super.start()
		m.view.setIsPlaying(false)
		m.metaData = null
		m.setVolume2(0)
		m.view.setLoadingProgress(0)
		m.view.bufferingStart()
		m.netStream.play(url)
	}

	override public function onStreamNetStatus(code:String):void {
		if (code == 'NetStream.Play.Start') {
			m.setState(new FirstFramesState(playOnStart))
		}
	}

	override public function pause():void {
		playOnStart = false
	}

	override public function resume():void {
		playOnStart = true
	}
}
class FirstFramesState extends VideoState {
	private var playOnStart:Boolean;

	public function FirstFramesState(playOnStart:Boolean) {
		this.playOnStart = playOnStart
	}

	override public function onInterval():void {
		super.onInterval()
		if (m.netStream.time > 0.5) {
			m.setVolume(m.volume)
			if (playOnStart) {
				m.setState(new PlayingState())
			} else {
				m.netStream.seek(0)
				m.setState(new PausedState())
			}
		}
	}

	override public function resume():void {
		playOnStart = true
	}

	override public function pause():void {
		playOnStart = false
	}
}
class PlayingState extends VideoState {
	private var playProgress:Number;

	override public function start():void {
		m.view.setIsPlaying(true)
		m.netStream.resume()
		playProgress = m.getPlayingProgress()
	}

	override public function onInterval():void {
		super.onInterval()
		var newProgress:Number = m.getPlayingProgress()
		if (newProgress != playProgress) {
			playProgress = newProgress
			m.view.setPlayingProgress(playProgress)
		}
	}

	override public function onStreamNetStatus(code:String):void {
		// m.dbg.log(code)
		switch(code) {
			case 'NetStream.Buffer.Empty':
				if (m.getLoadingProgress() > 0.98) {
					videoEnd()
				} else {
					m.setState(new BufferingState(false))
				}
				break;
			case 'NetStream.Play.Stop':
				videoEnd()
				break;
		}
	}

	private function videoEnd():void {
		if (m.view.isVideoLoop()) {
			m.netStream.seek(0)
			m.netStream.resume()
		}
	}

	override public function pause():void {
		m.setState(new PausedState())
	}
}
class BufferingState extends VideoState {
	private var isPaused:Boolean;
	private var iniTime:Number;

	public function BufferingState(isPaused:Boolean) {
		this.isPaused = isPaused
	}

	override public function start():void {
		m.view.setIsPlaying(false)
		iniTime = m.netStream.time
	}

	override public function onStreamNetStatus(code:String):void {
		if (code == 'NetStream.Buffer.Full') {
			if (isPaused) {
				m.setState(new PausedState())
			} else {
				m.setState(new PlayingState())
			}
		}
	}

	override public function resume():void {
		isPaused = false
	}

	override public function pause():void {
		isPaused = true
	}
}
class PausedState extends VideoState {
	override public function start():void {
		m.view.setIsPlaying(false)
		m.netStream.pause()
	}

	override public function resume():void {
		m.setState(new PlayingState())
	}
}
class NoVideoState extends State {
	override public function start():void {
		m.view.noVideo()
	}
}
