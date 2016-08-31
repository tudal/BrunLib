package pl.brun.lib.debugger.creation {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.controller.BDBitmapContentController;
	import pl.brun.lib.debugger.display.BDDisplayHighlighter;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDBitmapContent;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDDisplayHighlightManager;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDDisplayInfoModel;
	import pl.brun.lib.debugger.model.content.BDDisplayObjectBitmapModel;
	import pl.brun.lib.debugger.model.content.BDMethodsModel;
	import pl.brun.lib.debugger.model.content.BDVariablesModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;
	import pl.brun.lib.util.ClassUtils;

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDDisplayDebugServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;
		private var _displayHighlighter:BDDisplayHighlighter;

		public function BDDisplayDebugServiceCreation(display:DisplayObject, links:BDTextsManager, highlights:BDDisplayHighlightManager) {
			var title:String = ClassUtils.getClassNameByQualified(getQualifiedClassName(display));
			
			var modelsDisposeParent:Base = new Base();
			
			var bitmapper:BDDisplayObjectBitmapModel = new BDDisplayObjectBitmapModel(display, links.weaks);
			var bitmapperView:BDBitmapContent = new BDBitmapContent('screenshot', bitmapper, bitmapper);
			var bitmapController:BDBitmapContentController = new BDBitmapContentController(bitmapper, bitmapperView);
			bitmapper.addDisposeChild(bitmapController);
			
			var displayInfo:BDDisplayInfoModel = new BDDisplayInfoModel(display, links);
			var displayInfoView:BDTextContent = new BDTextContent("display info", displayInfo, links);
			
			var variables:BDVariablesModel = new BDVariablesModel(display, links);
			var variablesView:BDTextContent = new BDTextContent("var", variables, links);
			
			var methods:BDMethodsModel = new BDMethodsModel(display, links);
			var methodsView:BDTextContent = new BDTextContent("methods", methods, links);
			
			modelsDisposeParent.addDisposeChildren([displayInfo, variables, methods]);
			
			var contents:Array /*of BDAbstractContent*/ = [bitmapperView, displayInfoView, variablesView, methodsView];
			
			_displayHighlighter = highlights.getHighlightByDisplay(display);
			
			service = new BDCustomDebugService(title, contents, links.weaks, display, [_displayHighlighter]);
			service.addDisposeChildren([_displayHighlighter, bitmapper, modelsDisposeParent]);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}

		public function get displayHighlighter():BDDisplayHighlighter {
			return _displayHighlighter;
		}
	}
}
