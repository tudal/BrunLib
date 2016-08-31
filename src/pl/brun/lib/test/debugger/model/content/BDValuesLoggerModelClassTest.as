package pl.brun.lib.test.debugger.model.content {
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDValuesLoggerModelClassTest extends TestBase implements IBDWindowContentProvider {

		private var valuesModel:BDValuesLoggerModel;
		private var valuesView:BDTextContent;
		private var window:BDWindow;
		private var links:BDTextsManager;

		public function BDValuesLoggerModelClassTest() {
			
			var weaks:WeakReferences = new WeakReferences();
			links = new BDTextsManager(weaks);
			
			valuesModel = new BDValuesLoggerModel(links);
			valuesView = new BDTextContent('values', valuesModel, links);
			
			window = new BDWindow(this);
			holder.addChild(window.container);
			
			addTestKey('Q'.charCodeAt(0), setValue, ['qqqqq'], 'setValue("qqqqq");');			addTestKey('W'.charCodeAt(0), setValue, ['W', 643253], 'setValue("W", 643253);');			addTestKey('E'.charCodeAt(0), setRandomValue, ['E'], 'setRandomValue("E");');			addTestKey('R'.charCodeAt(0), setRandomValue, ['R'], 'setRandomValue("R");');
		}

		private function setValue(field:String, value:*= null):void {
			valuesModel.setValue(field, value);
		}

		private function setRandomValue(field:String):void {
			valuesModel.setValue(field, Math.random());
		}

		public function getWindowTitle():String {
			return 'title';
		}

		public function getWindowContents():Array {
			return [valuesView];
		}

		public function getServicedObject():Object {
			return this;
		}

		public function setIsWindowSelected(isSelected:Boolean):void 
		{
		}
		
		public function addDisposeChild(disposeChild:IDisposable):*
		{
		}
		
		public function addDisposeChildren(disposeChilds:Array):void
		{
		}
		
		public function dispose():void
		{
		}
		
		public function get isDisposed():Boolean {
			return false;
		}
	}
}
