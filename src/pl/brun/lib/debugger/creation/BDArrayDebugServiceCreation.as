package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDArrayListModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDArrayDebugServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;

		public function BDArrayDebugServiceCreation(array:Array, links:BDTextsManager) {
			var arrayList:BDArrayListModel = new BDArrayListModel(array, links);
			var arrayListView:BDTextContent = new BDTextContent('array', arrayList, links);
			
			service = new BDCustomDebugService('Array', [arrayListView], links.weaks, array);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}
	}
}
