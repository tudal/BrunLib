package pl.brun.lib.models.video2 {
	import flash.media.Video;
	/**
	 * @author Marek Brun
	 */
	public interface IVideoPlaybackView {
		
		function getVideo():Video;

		function noVideo():void;

		function bufferingStart():void;

		function setLoadingProgress(progress:Number):void;

		function setIsPlaying(boolean:Boolean):void;

		function setPlayingProgress(playProgress:Number):void;

		function isVideoLoop():Boolean;
		
	}
}
