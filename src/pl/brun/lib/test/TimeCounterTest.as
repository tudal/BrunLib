package pl.brun.lib.test {
	import pl.brun.lib.tools.TimeCounter;
	import pl.brun.lib.util.KeyCode;

	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class TimeCounterTest extends TestBase {
		private var time:TimeCounter;

		override protected function init():void {
			super.init()

			time = new TimeCounter()
			
			stage.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
			
			addTestKey(KeyCode.SPACE, switchStopped, null, "switchStopped()")
			addTestKey(KeyCode.R, restart, null, "restart()")
		}

		private function onStage_EnterFrame(event:Event):void {
			dbg.logv("time", time.getTime())
		}

		private function switchStopped():void {
			time.isStopped.value = !time.isStopped.value
		}

		private function restart():void {
			time.restart()
		}
	}
}
