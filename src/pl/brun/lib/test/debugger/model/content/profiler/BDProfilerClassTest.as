package pl.brun.lib.test.debugger.model.content.profiler {
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class BDProfilerClassTest extends TestBase implements IBDWindowContentProvider {

		private var textView:BDTextContent;
		private var addTrashTimer:Timer;
		private var trashes:Array /*of SomeTrash*/= [];

		public function BDProfilerClassTest() {
			addTrashTimer = new Timer(500);
			addTrashTimer.addEventListener(TimerEvent.TIMER, onAddTrashTimer_Timer);
			addTrashTimer.start();
			 			addTestKey(KeyCode.D, disposeSomeTrashInstances, null, 'disposeSomeTrashInstances()');
			
			dbg.log('As you can see in profiler - we have a memory leak! ;)');
		}

		private function disposeSomeTrashInstances():void {
			trashes = [];
		}
		
		public function getWindowTitle():String {
			return 'title';
		}

		public function getWindowContents():Array {
			return [textView];
		}

		public function getServicedObject():Object {
			return this;
		}

		public function setIsWindowSelected(isSelected:Boolean):void {
		}

		public function addDisposeChild(disposeChild:IDisposable):* {
		}

		public function addDisposeChildren(disposeChilds:Array):void {
		}

		public function dispose():void {
		}
		
		public function get isDisposed():Boolean {
			return false;
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onAddTrashTimer_Timer(event:TimerEvent):void {
			trashes.push(new SomeTrash());
		}
	}
}
