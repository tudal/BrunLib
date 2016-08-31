package pl.brun.lib.tools {
	import flash.events.Event;
	import flash.utils.getTimer;

	import pl.brun.lib.models.primitives.BooleanModel;
	import pl.brun.lib.Base;

	/**
	 * @author Marek Brun
	 */
	public class TimeCounter extends Base {
		private var _isStopped:BooleanModel;
		private var countedTime:uint;
		private var startTime:uint;

		public function TimeCounter(isStopped:BooleanModel = null) {
			restart()
			_isStopped = isStopped ? isStopped : new BooleanModel(true)
			_isStopped.addEventListener(Event.CHANGE, onIsStopped_Change)
		}

		private function onIsStopped_Change(event:Event):void {
			if (isStopped.value) {
				countedTime += getTimer() - startTime
			} else {
				startTime = getTimer()
			}
		}

		public function getTime():Number {
			if (isStopped.value) return countedTime;
			return countedTime + getTimer() - startTime
		}

		public function get isStopped():BooleanModel {
			return _isStopped;
		}

		public function restart():void {
			countedTime = 0
			startTime = getTimer()
		}
	}
}
