package pl.brun.lib.debugger.model.services {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDLoggerModel;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.debugger.windows.BDMainWindow;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * created: 2010-01-09
	 * @author Marek Brun
	 */
	public class BDObjectLogging extends Base {

		private var values:BDValuesLoggerModel;
		private var logging:BDLoggerModel;
		private var links:BDTextsManager;
		private var title:String;
		private var mainLogger:BDMainWindow;
		private var dictIDToTimer:Dictionary = new Dictionary();

		public function BDObjectLogging(obj:Object, logging:BDLoggerModel, values:BDValuesLoggerModel, links:BDTextsManager, mainLogger:BDMainWindow) {
			this.mainLogger = mainLogger
			this.links = links
			this.logging = logging
			this.values = values
			
			title = links.createLink(obj)
		}

		public function log(log:String):void {
			logging.addLog(log)
			mainLogger.titleLog(title, log)
		}

		public function logv(label:String, value:*):void {
			values.setValue(label, value)
		}

		public function time0(id:String):void {
			if (dictIDToTimer[id]) {
				throw new IllegalOperationError("id:" + id + " is already started")
			}
			dictIDToTimer[id] = getTimer()
		}

		public function time1(id:String):void {
			if (!dictIDToTimer[id]) {
				throw new IllegalOperationError("id:" + id + " is not started")
			}
			log("[t]"+id+':'+(getTimer()-dictIDToTimer[id]))
			delete dictIDToTimer[id]
		}

		override public function dispose():void {
			logging = null;
			links = null;
			values = null;
			super.dispose();
		}
	}
}
