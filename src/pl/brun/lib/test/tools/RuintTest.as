package pl.brun.lib.test.tools {
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.func.ruint;

	/**
	 * @author Marek Brun
	 */
	public class RuintTest extends TestBase {
		
		override protected function init():void {
			super.init()
			var i:uint = 10000
			var arr:Array = [0,0,0,0]
			while(--i){
				arr[ruint(3)]++
			}
			dbg.log("arr:"+dbg.link(arr, true))
		}
		
	}
}
