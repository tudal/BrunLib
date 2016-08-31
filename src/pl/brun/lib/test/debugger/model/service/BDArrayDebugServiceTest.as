package pl.brun.lib.test.debugger.model.service {
	import pl.brun.lib.debugger.creation.BDArrayDebugServiceCreation;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;

	/**
	 * created: 2009-12-25
	 * @author Marek Brun
	 */
	public class BDArrayDebugServiceTest extends TestBase {

		private var arr:Array;
		private var window:BDWindow;

		public function BDArrayDebugServiceTest() {
			
			arr = ['zero', 'one', 2, {}, this];
			
			var weaks:WeakReferences = new WeakReferences();
			var links:BDTextsManager = new BDTextsManager(weaks);
			var creator:BDArrayDebugServiceCreation = new BDArrayDebugServiceCreation(arr, links);
			
			window = new BDWindow(creator.windowContentProvider);
			holder.addChild(window.container);
		}
	}
}
