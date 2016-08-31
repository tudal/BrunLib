package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDObjectFieldsModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDObjectDebugServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;

		public function BDObjectDebugServiceCreation(obj:Object, links:BDTextsManager) {
			var title:String = 'Object';
			
			var fields:BDObjectFieldsModel = new BDObjectFieldsModel(obj, links);
			var fieldsView:BDTextContent = new BDTextContent('fields', fields, links);
			
			var contents:Array /*of BDAbstractContent*/ = [fieldsView];
			
			service = new BDCustomDebugService(title, contents, links.weaks, obj);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}
	}
}
