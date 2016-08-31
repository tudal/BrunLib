package pl.brun.lib.models {
	import pl.brun.lib.Base;
	import pl.brun.lib.util.func.htmlRedB;

	import flash.events.Event;
	import flash.utils.Dictionary;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * @author Marek Brun
	 */
	public class ChangeModel extends Base implements IExportImport {
		private var dictChildToExportID:Dictionary = new Dictionary(true);
		private var isImportingNow:Boolean;

		/*abstract*/
		protected function changed():void {
		}

		public function change():void {
			changed()
			dispatchEvent(new Event(Event.CHANGE))
		}

		protected function addChangeChild(child:ChangeModel, exportID:String, subToChanges:Boolean = true):void {
			if (subToChanges) {
				addEventSubscription(child, Event.CHANGE, onChild_Change)
			}
			if (exportID) {
				dictChildToExportID[child] = exportID
			}
		}

		private function onChild_Change(event:Event):void {
			if (isImportingNow) {
				return;
			}
			dbg.logv('setting changed', dictChildToExportID[event.target])
			change()
		}

		public function export():Object {
			var obj:Object = {}
			var exportID:String
			for (var model:* in dictChildToExportID) {
				exportID = dictChildToExportID[model]
				obj[exportID] = model.export()
			}
			return obj;
		}

		public function importt(obj:Object):void {
			isImportingNow = true
			var exportID:String
			for (var model:* in dictChildToExportID) {
				exportID = dictChildToExportID[model]
				if (obj[exportID]) {
					model.importt(obj[exportID])
				} else {
					dbg.log(htmlRedB('no import for exportID:' + dbg.link(exportID)))
				}
			}
			change()
			isImportingNow = false
		}
	}
}
