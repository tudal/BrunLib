package pl.brun.lib.test.tools {
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.tools.Timeout;

	/**
	 * 12-10-2013
	 * @author Marek Brun
	 */
	public class TimeoutTest extends TestBase {

		private var obj:Some;

		public function TimeoutTest(isDebugger:Boolean = true, isDarkBG:Boolean = false, fps:uint = 40, isBG:Boolean = true) {
			super(isDebugger, isDarkBG, fps, isBG);
		}

		override protected function start():void {
			obj = new Some()
			Timeout.sett(obj, 1000, obj.func)
			Timeout.sett(obj, 2000, obj.funcWithArgs, ['OK', 1])
			Timeout.sett(obj, 2500, obj.dispose)
			Timeout.sett(obj, 3000, obj.func)
			Timeout.sett(obj, 4000, obj.funcWithArgs, ['after dispose :(', 1])
		}
	}
}
import pl.brun.lib.Base;

class Some extends Base {

	public function Some() {
	}

	public function func():void {
		dbg.log("func(" + dbg.linkArr(arguments, true) + ')')
	}

	public function funcWithArgs(arg1:String, arg2:Number):void {
		dbg.log("funcWithArgs(" + dbg.linkArr(arguments, true) + ')')
	}
}