package pl.brun.lib.test.debugger.model.content {
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDLoggerModel;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.TestUtils;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDLoggerModelClassTest extends TestBase implements IBDWindowContentProvider {

		private var window:BDWindow;
		private var logModel:BDLoggerModel;
		private var textView:BDTextContent;
		private var lastText:String;
		private var lastTitle:String;
		private var logModel2:BDLoggerModel;
		private var textView2:BDTextContent;
		private var links:BDTextsManager;

		public function BDLoggerModelClassTest() {
			
			var weaks:WeakReferences=new WeakReferences();
			links = new BDTextsManager(weaks);
			
			logModel = new BDLoggerModel();
			textView = new BDTextContent('log1', logModel, links);
			logModel2 = new BDLoggerModel();
			textView2 = new BDTextContent('log2', logModel2, links);
			
			window = new BDWindow(this);
			holder.addChild(window.container);
			
			addTestKey('R'.charCodeAt(0), addRandomLog, null, 'addRandomLog();');
			addTestKey('A'.charCodeAt(0), addAgainLastLog, null, 'addAgainLastLog();');
			addTestKey('T'.charCodeAt(0), addRandomLogWithTitle, null, 'addRandomLogWithTitle();');
			addTestKey('S'.charCodeAt(0), addRandomLogWithSameTitle, null, 'addRandomLogWithSameTitle();');
			addTestKey('W'.charCodeAt(0), addAgainLastLogWithSameTitle, null, 'addAgainLastLogWithSameTitle();');
		}

		private function addRandomLog():void {
			lastText = TestUtils.getRandomOneLineText();
			logModel.addLog(lastText);
		}

		private function addRandomLogWithTitle():void {
			lastText = TestUtils.getRandomOneLineText();
			lastTitle = '<b>TITLE:' + TestUtils.getRandomOneLineText() + '</b>';
			logModel.addLogWithTitle(lastTitle, lastText);
		}

		private function addAgainLastLog():void {
			logModel.addLog(lastText);
		}

		private function addRandomLogWithSameTitle():void {
			lastText = TestUtils.getRandomOneLineText();
			logModel.addLogWithTitle(lastTitle, lastText);
		}

		private function addAgainLastLogWithSameTitle():void {
			logModel.addLogWithTitle(lastTitle, lastText);
		}

		public function getWindowTitle():String {
			return 'title';
		}

		public function getWindowContents():Array {
			return [textView, textView2];
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
