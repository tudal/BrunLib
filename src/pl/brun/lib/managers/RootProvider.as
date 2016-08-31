package pl.brun.lib.managers {
	import flash.display.Stage;

	import pl.brun.lib.Base;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author Marek Brun
	 */
	public class RootProvider extends Base {
		private static var instance:RootProvider;
		private static var stageGetError:Boolean;
		private static var stage:Stage;
		private var roott:DisplayObject;
		private var lastFrameTime:int;
		private var lastFrameDuration:int;

		public function RootProvider(root:DisplayObject) {
			this.roott = root
			lastFrameTime = getTimer();
			root.addEventListener(Event.ENTER_FRAME, onRoot_EnterFrame, false, 0, true);
		}

		private function onRoot_EnterFrame(event:Event):void {
			lastFrameDuration = getTimer() - lastFrameTime
			lastFrameTime = getTimer()
		}

		static public function getLastFrameDuration():uint {
			return getInstance()._getLastFrameDuration();
		}

		private function _getLastFrameDuration():uint {
			return lastFrameDuration;
		}

		public static function getRoot():DisplayObject {
			return getInstance().roott
		}

		public static function getStageOrRoot():DisplayObject {
			if (stage) {
				return stage
			}
			if (!stageGetError) {
				try {
					if (getInstance().roott.stage) {
						stage = getInstance().roott.stage
						stage.addEventListener(Event.DEACTIVATE, getInstance().onde)
						stage.removeEventListener(Event.DEACTIVATE, getInstance().onde)
						return stage
					}
				} catch(e:Error) {
					stageGetError = true
					stage = null
				}
			}
			return getInstance().roott
		}

		private function onde(event:Event):void {
		}

		static public function getInstance():RootProvider {
			if (instance) {
				return instance;
			} else {
				throw new Error('Before calling RootProvider.getInstance() please call RootProvider.init()');
			}
		}

		static public function init(root:DisplayObject):void {
			if (instance) {
				return;
			} else {
				instance = new RootProvider(root);
			}
		}
	}
}

/*



		public function StageProvider(access:Private, stage:Stage) {
			this.stage = stage;
			lastFrameTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		static public function getLastFrameDuration():uint {
			return getInstance()._getLastFrameDuration();
		}

		static public function getStage():Stage {
			return getInstance()._getStage();
		}

		private function _getStage():Stage {
			return stage;
		}

		private function _getLastFrameDuration():uint {
			return lastFrameDuration;
		}

		static public function getInstance():StageProvider {
			if (instance) {
				return instance;
			} else {
				throw new Error('Before calling StageProvider.getInstance() please call StageProvider.init()');
			}
		}

		static public function init(stage:Stage):void {
			if (instance) {
				return;
			} else {
				instance = new StageProvider(null, stage);
				CallOncePerFrame2.init()
			}
		}

		// --------------------------------------------------------------------------
		// handlers
		// --------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			lastFrameDuration = getTimer() - lastFrameTime;
			lastFrameTime = getTimer();
		}
 */