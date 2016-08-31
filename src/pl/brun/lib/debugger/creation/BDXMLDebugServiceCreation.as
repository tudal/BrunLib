package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDXMLShowModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDXMLDebugServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;

		public function BDXMLDebugServiceCreation(xml:XML, links:BDTextsManager) {
			var title:String = 'XML';
			
			var xmlShow:BDXMLShowModel= new BDXMLShowModel(xml, links.weaks);
			var textView:BDTextContent = new BDTextContent('toXMLString();', xmlShow, links);
			
			var contents:Array /*of BDAbstractContent*/ = [textView];
			
			service = new BDCustomDebugService(title, contents, links.weaks, xml);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}

	}
}
