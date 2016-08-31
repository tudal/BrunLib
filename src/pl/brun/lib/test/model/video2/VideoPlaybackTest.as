package pl.brun.lib.test.model.video2 {
	import pl.brun.lib.models.video2.IVideoPlaybackView;
	import pl.brun.lib.util.KeyCode;

	import flash.media.Video;

	import pl.brun.lib.models.video2.VideoPlayback;
	import pl.brun.lib.test.TestBase;

	/**
	 * @author Marek Brun
	 */
	public class VideoPlaybackTest extends TestBase implements IVideoPlaybackView {
		private var playback:VideoPlayback;
		private var video:Video;
		private var isLoop:Boolean = true;
		private var isPlaying:Boolean;

		override protected function init():void {
			super.init()

			video = new Video()
			addChild(video)

			playback = new VideoPlayback(this)

			addTestKey(KeyCode.n1, startPaused, null, 'startPaused()')
			addTestKey(KeyCode.n2, startPlaying, null, 'startPlaying()')
			addTestKey(KeyCode.S, switchLoop, null, 'switchLoop()')
			addTestKey(KeyCode.P, switchPlaying, null, 'switchPlaying()')
		}

		private function switchPlaying():void {
			if(isPlaying){
				playback.pause()
			}else{
				playback.resume()
			}
		}

		private function switchLoop():void {
			isLoop = !isLoop
			dbg.log("isLoop:" + dbg.link(isLoop, true))
		}

		private function startPaused():void {
			playback.startPlay('sampleShort.flv', false)
		}

		private function startPlaying():void {
			playback.startPlay('sampleShort.flv', true)
		}

		public function getVideo():Video {
			return video;
		}

		public function noVideo():void {
			dbg.log("noVideo(" + dbg.linkArr(arguments, true) + ')')
		}

		public function bufferingStart():void {
			dbg.log("bufferingStart(" + dbg.linkArr(arguments, true) + ')')
		}

		public function setLoadingProgress(progress:Number):void {
			dbg.log("setLoadingProgress(" + dbg.linkArr(arguments, true) + ')')
		}

		public function setIsPlaying(boolean:Boolean):void {
			isPlaying = boolean
			dbg.log("setIsPlaying(" + dbg.linkArr(arguments, true) + ')')
		}

		public function setPlayingProgress(playProgress:Number):void {
			dbg.log("setPlayingProgress(" + dbg.linkArr(arguments, true) + ')')
		}

		public function isVideoLoop():Boolean {
			return isLoop;
		}
	}
}
