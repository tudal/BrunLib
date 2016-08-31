package pl.brun.lib.debugger.model {
	import pl.brun.lib.Base;
	import pl.brun.lib.tools.Averager;

	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author Marek Brun
	 */
	public class FPSMeter extends Base {
		private var average:Averager;
		private var lastTime:int;

		public function FPSMeter() {
			average = new Averager(stage.frameRate)
			lastTime = getTimer()
			stage.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
		}

		private function onStage_EnterFrame(event:Event):void {
			var t:int = getTimer()
			average.push(t - lastTime)
			lastTime = t
		}

		public function getFPS():Number {
			return 1000 / average.getAverage()
		}
		
	}
}
