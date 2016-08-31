package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDTextModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;
	import pl.brun.lib.util.StringUtils;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDBigStringServiceCreation implements IBDDebugServiceCreation {

		private var service:BDCustomDebugService;

		public function BDBigStringServiceCreation(string:String, links:BDTextsManager) {
			var title:String = 'String';
			
			var text:BDTextModel= new BDTextModel();
			text.setText(StringUtils.safeHTML(string));
			var textView:BDTextContent = new BDTextContent('string', text, links);
			
			var contents:Array /*of BDAbstractContent*/ = [textView];
			
			service = new BDCustomDebugService(title, contents, links.weaks);
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}
	}
}
