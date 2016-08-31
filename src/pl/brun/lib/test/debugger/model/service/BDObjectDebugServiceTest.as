package pl.brun.lib.test.debugger.model.service {
	import pl.brun.lib.debugger.creation.BDComplexDebugServiceCreation;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDObjectDebugServiceTest extends TestBase {

		private var window:BDWindow;
		private var testObj:TestObject;

		public function BDObjectDebugServiceTest() {
			testObj = new TestObject();
			
			var weaks:WeakReferences = new WeakReferences();
			var links:BDTextsManager = new BDTextsManager(weaks);
			
			var creation:BDComplexDebugServiceCreation = new BDComplexDebugServiceCreation(testObj, links, null);
			
			window = new BDWindow(creation.windowContentProvider);
			holder.addChild(window.container);
		}
	}
}
