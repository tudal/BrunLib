package pl.brun.lib.debugger.model.services {
	import pl.brun.lib.Base;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.model.IBDEnable;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.models.WeakReferences;

	/**
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public class BDCustomDebugService extends Base implements IBDWindowContentProvider {

		private var windowContents:Array/*of BDAbstractContent*/;
		private var title:String;
		private var enablers:Array/*of IBDEnable*/;
		private var weaks:WeakReferences;
		private var servicedObjectRID:uint;

		public function BDCustomDebugService(title:String, windowContents:Array/*of BDAbstractContent*/, weaks:WeakReferences, servicedObject:Object = null, enablers:Array /*of IBDEnable*/= null) {
			this.weaks = weaks;
			this.title = title;
			this.windowContents = windowContents;
			if(servicedObject) {
				servicedObjectRID = weaks.getID(servicedObject);
				if(servicedObject is IDisposable){
					IDisposable(servicedObject).addEventListener(EventPlus.BEFORE_DISPOSED, onServicedObject_Dispose, false, 0, true);
				}
			}
			this.enablers = enablers;
		}

		public function setIsWindowSelected(isSelected:Boolean):void {
			if(!enablers) {
				return;
			}
			var i:uint;
			var enabler:IBDEnable;
			for(i = 0;i < enablers.length;i++) {
				enabler = enablers[i];
				enabler.isEnabled = isSelected;
			}
		}

		public function getWindowTitle():String {
			return title;
		}

		public function getWindowContents():Array /*of BDAbstractContent*/ {
			return windowContents;
		}

		public function getServicedObject():Object {
			return weaks.getValue(servicedObjectRID);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onServicedObject_Dispose(event:EventPlus):void {
			dispose();
		}
	}
}
