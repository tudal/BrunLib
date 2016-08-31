package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.models.IResizable;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Marek Brun
	 */
	public class ResizeToStageController extends Base {

		private var resizable:IResizable;
		private var width:Number = 0;
		private var height:Number = 0;
		private var checkTimer:Timer;

		public function ResizeToStageController(resizable:IResizable) {
			this.resizable = resizable;
			addEventSubscription(StageProvider.getStage(), Event.RESIZE, onStage_Resize);
			resizeToStage()
			checkTimer = new Timer(10000)
			checkTimer.addEventListener(TimerEvent.TIMER, onCheckTimer_Timer)
			checkTimer.start()
		}

		private function onCheckTimer_Timer(event:TimerEvent):void {
			if (stage.stageWidth > 0) {
				if (stage.stageWidth != width || stage.stageHeight != height) {
					resizeToStage()
				}
			}
		}

		private function resizeToStage():void {
			width = stage.stageWidth
			height = stage.stageHeight
			if (stage.stageWidth > 0) {
				resizable.setSize(width, height);
			}
		}

		private function onStage_Resize(event:Event):void {
			resizeToStage();
		}

		override public function dispose():void {
			checkTimer.stop()
			super.dispose()
		}
	}
}
