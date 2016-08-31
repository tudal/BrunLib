package pl.brun.lib.models {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import pl.brun.lib.Base;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * @author Marek Brun
	 */
	public class SpeedMeter extends Base {
		private var mesureTime:uint;
		private var mesureTimer:Timer;
		private var lastRead:Number;
		private var value:Number;

		public function SpeedMeter(mesureTime:uint) {
			this.mesureTime = mesureTime
			mesureTimer = new Timer(mesureTime)
			mesureTimer.addEventListener(TimerEvent.TIMER, onMesureTimer_Complete)
			mesureTimer.start()
		}

		public function addValue(value:Number):void {
			this.value = value
		}

		private function onMesureTimer_Complete(event:TimerEvent):void {
			lastRead
			dispatchEvent(new Event(Event.COMPLETE))
		}
		
	}
}
