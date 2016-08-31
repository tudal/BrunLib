package pl.brun.lib.debugger {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * created: 2010-01-09
	 * @author Marek Brun
	 */
	public class DebugServiceProxy {

		/** Debugger instance */
		public static var debugger:Object;
		// IDebugger
		/** BDObjectLogging */
		private var logging:Object;
		private var obj:Object;
		public var logvID:String;
		public var logvID2:String;
		public var logvStyle0:String = '<FONT COLOR="#999999">';
		public var logvStyle1:String = '</FONT>  ';
		private static const servicedObjects:Dictionary = new Dictionary(true);
		public var enabled:Boolean = true;
		public static var prelog:Boolean = false;

		public function DebugServiceProxy(obj:Object) {
			if (debugger) {
				this.obj = obj;
				logging = debugger.getLogging(obj);
			}
		}

		public function dispose():void {
			obj = null
			if (logging) {
				logging.dispose()
			}
		}

		public function registerInDisplay(mc:DisplayObject):void {
		}

		public function show():void {
			if (debugger) {
				debugger.showWindow(obj);
			}
		}

		public function showObj(obj:*):void {
			if (debugger) {
				debugger.showWindow(obj);
			}
		}

		public function logRed(text:*):void {
			log('<FONT COLOR="#FF0000">' + text + '</FONT>')
		}

		public function log(text:*):void {
			if (prelog && (logvID || logvID2)) {
				text = logvID + ' ' + logvID2 + '\n	' + text
			}
			if (debugger && enabled) {
				if (logging) {
					logging.log(text);
				} else {
					debugger.mainLogger.objectLog(obj, text);
				}
			}
		}

		public function timeStart(id:String):void {
			if (debugger && enabled) {
				debugger.sppedTestStart(id);
			}
		}

		public function timeStop(id:String):void {
			if (debugger && enabled) {
				debugger.sppedTestStop(id);
			}
		}

		public function t0(id:String):void {
			if (debugger && enabled) {
				if (logging) {
					logging.time0(id);
				}
			}
		}

		public function t1(id:String):void {
			if (debugger && enabled) {
				if (logging) {
					logging.time1(id);
				}
			}
		}

		public function logv(label:String, value:*=null):void {
			if (debugger && enabled) {
				if (logvID) {
					if (logvID2) {
						label = logvStyle0 + '[' + logvID + '-' + logvID2 + ']  ' + logvStyle1 + label
					} else {
						label = logvStyle0 + '[' + logvID + ']  ' + logvStyle1 + label
					}
				}
				debugger.logv.setValue(label, value);
				if (logging) {
					logging.logv(label, value);
				}
			}
		}

		public function link(value:*, isRemember:Boolean = false):String {
			if (debugger && enabled) {
				return debugger.links.createLink(value, isRemember);
			}
			return '(no debugger!)';
		}

		public function linkArr(arr:Array, isRemember:Boolean = false, limit:uint = 4):String {
			var links:Array/*of String*/ 
			= [];
			var i:uint;
			for (i = 0;i < arr.length;i++) {
				links.push(link(arr[i], isRemember));
				if (i > limit) {
					links.push('...');
					break;
				}
			}
			return links.join(', ');
		}

		public function registerInContex(context:*):void {
			if (debugger && enabled) {
				debugger.mainLogger.registerInContex(obj, context);
			}
		}

		public function contextLog(context:*, logText:String):void {
			if (debugger && enabled) {
				debugger.mainLogger.contextLog(obj, context, logText);
			}
		}

		public static function forInstance(obj:Object):DebugServiceProxy {
			if (!servicedObjects[obj]) {
				servicedObjects[obj] = new DebugServiceProxy(obj);
			}
			return servicedObjects[obj];
		}
	}
}
