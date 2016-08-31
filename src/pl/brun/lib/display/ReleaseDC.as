package pl.brun.lib.display {
	import pl.brun.lib.managers.CurrentTime;
	import pl.brun.lib.errors.NoImplementationError;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.util.func.delayCall;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * created:2011-03-04  15:33:02
	 * @author Marek Brun
	 */
	public class ReleaseDC extends MovieClip {

		private var fps:uint;
		protected var _centerHolder:Sprite;

		public function ReleaseDC(fps:uint = 40) {
			this.fps = fps;
			_centerHolder = new Sprite()
			addChild(_centerHolder)
			RootProvider.init(this)
			if(stage) {
				init()
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onThis_AddedToStage);
			}
		}

		public function start():void {
			throw new NoImplementationError()
		}

		protected function init():void {
			CurrentTime.init(new Date().getTime())
			StageProvider.init(stage)
			if(!(parent is Loader)) {
				stage.frameRate = fps
				stage.align = StageAlign.TOP_LEFT
				stage.scaleMode = StageScaleMode.NO_SCALE
			}
			
			stage.addEventListener(Event.RESIZE, onStage_Resize, false, 0, true)
			alignToStage()
			delayCall(start)
		}

		protected function alignToStage():void {
			if(stage && centerHolder){
				centerHolder.x = stage.stageWidth / 2
				centerHolder.y = stage.stageHeight / 2
			}
		}

		public function get centerHolder():Sprite {
			return _centerHolder;
		}

		private function onStage_Resize(event:Event):void {
			alignToStage();
		}

		private function onThis_AddedToStage(event:Event):void {
			init();
		}

		protected function addEventSubscription(obj:IEventDispatcher, type:String, listener:Function):void {
			obj.addEventListener(type, listener)
		}

		protected function removeEventSubscription(obj:IEventDispatcher, type:String, listener:Function):void {
			obj.removeEventListener(type, listener)
		}
	}
}
