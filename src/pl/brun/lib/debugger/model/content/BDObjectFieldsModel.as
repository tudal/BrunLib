package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;

	import flash.events.Event;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDObjectFieldsModel extends Base implements IBDTextContentProvider, IBDRefreshable {

		private var text:String;
		private var links:BDTextsManager;
		private var objRID:uint;

		public function BDObjectFieldsModel(obj:Object, links:BDTextsManager) {
			this.links = links;
			objRID = links.weaks.getID(obj);
			refresh();
		}

		public function refresh():void {
			var obj:Object = links.weaks.getValue(objRID);
			
			var fields:Array /*of String*/= [];
			for(var i:String in obj) {
				fields.push(links.formatFieldName(i) + ' = ' + links.createLink(obj[i]));
			}
			fields.sort();
			text = fields.join('\n');
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getText():String {
			return text;
		}
	}
}
