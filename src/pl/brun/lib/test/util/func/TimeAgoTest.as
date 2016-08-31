package pl.brun.lib.test.util.func {
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;
	import pl.brun.lib.util.TimeInMs;
	import pl.brun.lib.util.func.timeAgo;

	/**
	 * @author Marek Brun
	 */
	public class TimeAgoTest extends TestBase {
		override protected function init():void {
			super.init()
			addTestKey(KeyCode.n1, test, [TimeInMs.YEAR * 3], "test(3 years)")
			addTestKey(KeyCode.n2, test, [TimeInMs.YEAR], "test(year)")
			addTestKey(KeyCode.n3, test, [TimeInMs.MONTH * 2], "test(2 months)")
			addTestKey(KeyCode.n4, test, [TimeInMs.DAY * 2], "test(2 days)")
			addTestKey(KeyCode.n5, test, [TimeInMs.HOUR * 2], "test(2 hours)")
		}

		private function test(max:Number):void {
			var time:Number = Math.random() * max
			dbg.log("time:" + dbg.link(time, true) + ' ' + uint(time / TimeInMs.WEEK) + ' ' + uint(time / TimeInMs.DAY) + ' ' + uint(time / TimeInMs.HOUR) + ' ' + uint(time / TimeInMs.MINUTE))
			var ago:String = timeAgo(time)
			dbg.log("ago:" + dbg.link(ago, true))
		}
	}
}
