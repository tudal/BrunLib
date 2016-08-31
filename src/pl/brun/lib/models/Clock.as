package pl.brun.lib.models {
	import flash.events.Event;

	import pl.brun.lib.Base;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * New minute (also hour, day, week, etc)
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @author Marek
	 */
	public class Clock extends Base {
		
		private var timer:Timer;

		public function Clock() {
			timer = new Timer(1, 1)
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onClockTimer_Timer)
			restartClockTimer()
		}

		private function restartClockTimer():void {
			var now:Date = new Date()
			var toChange:Number = 60000 - now.getSeconds() * 1000 + now.getMilliseconds() + 100
			timer.delay = toChange
			timer.reset()
			timer.start()
		}

		private function onClockTimer_Timer(event:TimerEvent):void {
			dispatchEvent(new Event(Event.CHANGE))
			restartClockTimer()
		}
	}
}
