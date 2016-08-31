package pl.brun.lib.tools {
	import pl.brun.lib.Base;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;

	[Event(name="enterFrame", type="flash.events.Event")]
	[Event(name="timerComplete", type="flash.events.TimerEvent")]
	/**
	 * @author Marek
	 */
	public class EFTimer extends Base {
		public var delay:Number = 1000;
		private var timeToGo:Number;
		private var lastTimer:int;
		private var isStarted:Boolean;
		private var isPaused:Boolean;
		private var progress:Number = 0;

		public function EFTimer(delay:Number) {
			this.delay = delay
		}

		public function getProgress():Number {
			if (isStarted) {
				progress = Math.min(1, 1 - (timeToGo / delay))
			}
			return progress;
		}

		public function restart():void {
			isStarted = false
			start()
		}

		public function start():void {
			if (isStarted) return;
			isPaused = false
			isStarted = true
			lastTimer = getTimer()
			timeToGo = delay
			addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileRunning)
		}

		public function pause():void {
			if (!isStarted) return;
			if (isPaused) return;
			isPaused = true
			timeToGo -= getTimer() - lastTimer
			removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileRunning)
		}

		public function resume():void {
			if (!isStarted) return;
			if (!isPaused) return;
			isPaused = false
			lastTimer = getTimer()
			addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileRunning)
		}

		public function cancel():void {
			if (!isStarted) return;
			isStarted = false
			removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileRunning)
		}

		private function onStage_EnterFrame_WhileRunning(event:Event):void {
			if (getProgress() >= 1) {
				isStarted = false
				removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileRunning)
				dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE))
			} else {
				timeToGo -= getTimer() - lastTimer
				lastTimer = getTimer()
				dispatchEvent(new Event(Event.ENTER_FRAME))
			}
		}
	}
}
