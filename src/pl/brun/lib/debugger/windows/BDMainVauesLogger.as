package pl.brun.lib.debugger.windows {
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDMainVauesLogger extends BDWindow {

		private var _logv:BDValuesLoggerModel;
		private var logView:BDTextContent;
		private var service:BDCustomDebugService;

		public function BDMainVauesLogger(links:BDTextsManager) {
			
			_logv = new BDValuesLoggerModel(links);
			logView = new BDTextContent('values', _logv, links);
			
			service = new BDCustomDebugService('main values logger', [logView], links.weaks);
			service.addDisposeChild(_logv);			service.addDisposeChild(logView);
			addDisposeChild(service);
			
			super(service);
		}

		public function get logv():BDValuesLoggerModel {
			return _logv;
		}
	}
}
