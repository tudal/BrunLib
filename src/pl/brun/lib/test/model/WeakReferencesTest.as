package pl.brun.lib.test.model {
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;

	/**
	 * created: 2010-01-12
	 * @author Marek Brun
	 */
	public class WeakReferencesTest extends TestBase {

		private var weaks:WeakReferences;
		private var localVarObjRID:uint;

		public function WeakReferencesTest() {
			
			dbg.log('dsdsa');
			
			var localVarObj:Object = {};
			
			weaks = new WeakReferences();
			localVarObjRID = weaks.getID(localVarObj);
						addTestKey(KeyCode.SPACE, test, null, 'test');
			
			test();
		}

		private function test():void {
			dbg.log('weaks.getValue(localVarObjRID):' + weaks.getValue(localVarObjRID));
		}
	}
}
