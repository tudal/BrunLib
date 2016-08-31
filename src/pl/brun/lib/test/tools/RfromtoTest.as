package pl.brun.lib.test.tools {
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.func.rfromto;

	/**
	 * @author Marek Brun
	 */
	public class RfromtoTest extends TestBase {
		
		override protected function init():void {
			super.init()
			var i:uint = 10000
			var arr:Array = [0,0,0,0]
			while(--i){
				arr[rfromto(1, 3)]++
			}
			dbg.log("arr:"+dbg.link(arr, true))
		}
		
	}
}
