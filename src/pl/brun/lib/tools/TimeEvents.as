package pl.brun.lib.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.SelectIndexEvent;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getTimer;

	[Event(name="selectRequest", type="pl.brun.lib.events.SelectIndexEvent")]
	/**
	 * @author Marek Brun
	 */
	public class TimeEvents extends Base {
		private var startTime:uint;
		private var times:Array;
		private var nextTime:*;
		private var index:uint;
		private var timesORG:Array;

		public function TimeEvents(times:Array) {
			timesORG = times
			index = 0
		}

		public function start(force:Boolean=false):void {
			if (!timesORG.length) throw new IllegalOperationError("no times");
			times = timesORG.concat()
			times.sort(Array.NUMERIC)
			nextTime = times.shift()
			if (startTime && !force) throw new IllegalOperationError("already started");
			startTime = getTimer()
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
		}

		private function onStage_EnterFrame(event:Event):void {
			var currentTime:int = getTimer() - startTime
			if (currentTime > nextTime) {
				dispatchEvent(new SelectIndexEvent(SelectIndexEvent.SELECT_REQUEST, timesORG.indexOf(nextTime)))
				if (times.length) {
					index++
					nextTime = times.shift()
				} else {
					root.removeEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
				}
			}
		}
	}
}
