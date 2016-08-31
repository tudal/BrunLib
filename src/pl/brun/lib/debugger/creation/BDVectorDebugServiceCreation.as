package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDVectorListModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDVectorDebugServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;

		public function BDVectorDebugServiceCreation(vect:*, links:BDTextsManager) {
			var arrayList:BDVectorListModel = new BDVectorListModel(vect, links);
			var arrayListView:BDTextContent = new BDTextContent('vector', arrayList, links);
			
			service = new BDCustomDebugService('Vector', [arrayListView], links.weaks, vect);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}
	}
}
