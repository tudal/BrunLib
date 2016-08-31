package pl.brun.lib.debugger.windows {
	import pl.brun.lib.debugger.model.content.BDSpeedTestModel;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.content.BDProfilerTextContent;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDLoggerModel;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.debugger.model.content.profiler.BDProfiler;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;

	import flash.utils.Dictionary;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDMainWindow extends BDWindow {

		private var logger:BDLoggerModel;
		private var logView:BDTextContent;
		private var service:BDCustomDebugService;
		private var links:BDTextsManager;
		private var dictContext_SendersDict:Dictionary = new Dictionary();
		private var _logv:BDValuesLoggerModel;
		private var logVView:BDTextContent;
		private var profiler:BDProfiler;
		private var profilerView:BDTextContent;
		private var speedMeter:BDSpeedTestModel;
		private var speedMeterView:BDTextContent;

		public function BDMainWindow(links:BDTextsManager) {
			
			this.links = links;
			logger = new BDLoggerModel();
			logView = new BDTextContent('log', logger, links);
			logView.isScrollToDown = true
			
			_logv = new BDValuesLoggerModel(links);
			logVView = new BDTextContent('values', _logv, links);
			
			profiler = new BDProfiler(links);
			profilerView = new BDProfilerTextContent('profiler', profiler, links);
			
			speedMeter = new BDSpeedTestModel(links);
			speedMeterView = new BDTextContent('times', speedMeter, links);
			
			service = new BDCustomDebugService('Main debug', [logView, logVView, profilerView, speedMeterView], links.weaks);
			service.addDisposeChild(logger);			service.addDisposeChild(logView);
			service.addDisposeChild(_logv);
			service.addDisposeChild(logVView);
			service.addDisposeChild(speedMeter);
			service.addDisposeChild(speedMeterView);
			addDisposeChild(service);
			
			super(service);
		}

		public function get logv():BDValuesLoggerModel {
			return _logv;
		}

		public function registerInContex(sender:Object, context:*):void {
			if(!dictContext_SendersDict[context]) {
				dictContext_SendersDict[context] = new Dictionary(true);
			}
			dictContext_SendersDict[context][sender] = true;
		}

		public function contextLog(sender:Object, context:*, logText:String):void {
			if(!dictContext_SendersDict[context]) {
				return;
			}
			if(dictContext_SendersDict[context][sender]) {
				objectLog(sender, '(c:<b>' + context + '</b>):' + logText);
			}
		}

		public function log(logText:String):void {
			logger.addLog(logText);
		}

		public function objectLog(object:Object, logText:String):void {
			logger.addLogWithTitle(links.createLink(object), logText);
		}

		public function titleLog(title:String, logText:String):void {
			logger.addLogWithTitle(title, logText);
		}

		public function sppedTestStart(id:String):void {
			speedMeter.start(id)
		}

		public function sppedTestStop(id:String):void {
			speedMeter.finish(id)
		}
	}
}
