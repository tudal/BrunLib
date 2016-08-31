package pl.brun.lib.test.model.video {
	import pl.brun.lib.models.video.VideoPlaybackEvent;
	import pl.brun.lib.models.video.VideoPlaybackModel;
	import pl.brun.lib.test.TestBase;

	import flash.events.Event;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;

	/**
	 * @author Marek Brun
	 */
	public class VPMTest extends TestBase {
		private var video:Video;
		private var vpm:VideoPlaybackModel;
		private var loader:URLLoader;

		override protected function init():void {
			super.init()

			loader = new URLLoader()
			loader.addEventListener(Event.COMPLETE, onLoader_Complete)
			loader.dataFormat = URLLoaderDataFormat.BINARY
			loader.load(new URLRequest("http://brun.pl/misc/test.flv"))
		}

		private function onLoader_Complete(event:Event):void {
			video = new Video()
			addChild(video)
			vpm = new VideoPlaybackModel(video)
			vpm.startPlayByteArray(loader.data)
			vpm.addEventListener(VideoPlaybackEvent.PLAYING_PROGRESS_CHANGED, onvideoStart)
			vpm.addEventListener(VideoPlaybackEvent.BUFFERING_FINISH, onPlayback_VideoEnd)

			setTimeout(unpause, 3000)
		}

		private function onPlayback_VideoEnd(event:VideoPlaybackEvent):void {
			dbg.log("onPlayback_VideoEnd("+dbg.linkArr(arguments, true)+')')
		}

		private function unpause():void {
			dbg.log("unpause(" + dbg.linkArr(arguments, true) + ')')
			vpm.setIsPlaying(true)
		}

		private function onvideoStart(event:VideoPlaybackEvent):void {
			vpm.removeEventListener(VideoPlaybackEvent.PLAYING_PROGRESS_CHANGED, onvideoStart)
			vpm.setIsPlaying(false)
		}
	}
}
