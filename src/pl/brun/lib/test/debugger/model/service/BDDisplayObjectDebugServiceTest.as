package pl.brun.lib.test.debugger.model.service {
	import pl.brun.lib.debugger.creation.BDDisplayDebugServiceCreation;
	import pl.brun.lib.debugger.managers.BDDisplayHighlightManager;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.debugger.display.BDWindowClassTest;

	import flash.display.MovieClip;
	import flash.filters.GlowFilter;

	/**
	 * created: 2009-12-25
	 * @author Marek Brun
	 */
	public class BDDisplayObjectDebugServiceTest extends BDWindowClassTest {

		private var servidecMC:MovieClip;

		public function BDDisplayObjectDebugServiceTest() {
			
			servidecMC = new BFLA_animtoDebug2MC();
			servidecMC.filters = [new GlowFilter()];
			servidecMC.scaleY = 0.5;
			servidecMC.x = 100;
			servidecMC.y = 200; 
			
			var weaks:WeakReferences = new WeakReferences();
			var links:BDTextsManager = new BDTextsManager(weaks);
			var highligths:BDDisplayHighlightManager = new BDDisplayHighlightManager();
			
			var creation:BDDisplayDebugServiceCreation = new BDDisplayDebugServiceCreation(servidecMC, links, highligths);
						holder.addChild(highligths.container);
			
			holder.addChild(servidecMC);
			
			createWindow(creation.windowContentProvider);
			
		}
	}
}
