package pl.brun.lib.test.tools {
	import pl.brun.lib.events.SelectIndexEvent;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.tools.TimeEvents;

	import flash.utils.getTimer;

	/**
	 * @author Marek Brun
	 */
	public class TimeEventsTest extends TestBase {
		private var timeEvents:TimeEvents;
		private var startTime:int;

		override protected function init():void {
			super.init()
			var times:Array = [5770, 10000, 16660, 18300]
			dbg.log("times:" + dbg.linkArr(times))
			timeEvents = new TimeEvents(times)
			timeEvents.addEventListener(SelectIndexEvent.SELECT_REQUEST, onTimeEvents_SelectRequest)
			timeEvents.start()
			startTime = getTimer()
		}

		private function onTimeEvents_SelectRequest(event:SelectIndexEvent):void {
			var currTime:int = getTimer() - startTime
			dbg.log("event.index:" + dbg.link(event.index, true) + '  currTime:' + dbg.link(currTime, true))
		}
		
	}
}
