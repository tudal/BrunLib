package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.util.StringUtils;

	/**
	 * created: 2010-01-12
	 * @author Marek Brun
	 */
	public class BDXMLShowModel extends Base implements IBDRefreshable, IBDTextContentProvider {

		private var xmlToString:*;
		private var xmlRID:uint;
		private var weaks:WeakReferences;

		public function BDXMLShowModel(xml:XML, weaks:WeakReferences) {
			this.weaks = weaks;
			xmlRID = weaks.getID(xml);
			refresh();
		}

		public function refresh():void {
			XML.prettyPrinting = true;
			xmlToString = StringUtils.safeHTML(weaks.getValue(xmlRID).toXMLString());
		}

		public function getText():String {
			return xmlToString;
		}
	}
}
