package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDValuesLoggerModel extends Base implements IBDTextContentProvider {

		private var fields:Dictionary = new Dictionary();		private var fieldCounts:Dictionary = new Dictionary();
		private var links:BDTextsManager;

		public function BDValuesLoggerModel(links:BDTextsManager) {
			this.links = links;
		}

		public function setValue(field:String, value:* = null):void {
			if(!fieldCounts[field]) {
				fieldCounts[field] = 0;
			}
			fieldCounts[field]++;
			fields[field] = value;
			
			dispatchChange()
		}

		private function dispatchChange():void {
			dispatchEvent(new Event(Event.CHANGE));			
		}


		public function getText():String {
			var text:Array = [];
			for(var field:String in fields) {
				if(fields[field] == null) {
					text.push(links.formatFieldName(field) + '  *' + fieldCounts[field]);
				} else {
					text.push(links.formatFieldName(field) + ' = ' + fields[field] + '   *' + fieldCounts[field]);
				}
			}
			text.sort()
			return text.join('\n');
		}
	}
}
