package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;

	/**
	 * created: 2009-12-25
	 * @author Marek Brun
	 */
	public class BDArrayListModel extends Base implements IBDTextContentProvider, IBDRefreshable {

		private var text:String;
		private var links:BDTextsManager;
		private var arrRID:uint;

		public function BDArrayListModel(arr:Array, links:BDTextsManager) {
			this.links = links;
			arrRID = links.weaks.getID(arr);
			refresh();
		}

		public function refresh():void {
			var lines:Array /*of String*/= [];
			
			var arr:Array = links.weaks.getValue(arrRID);
			
			var i:uint;
			var item:*;
			for(i = 0;i < arr.length;i++) {
				item = arr[i];
				lines.push('[' + i + '] = ' + links.createLink(item));
			}
			
			text = lines.join('\n');
		}

		public function getText():String {
			return text;
		}
	}
}
