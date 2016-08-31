package pl.brun.lib.test {
	import pl.brun.lib.actions.ActionsQueue;
	import pl.brun.lib.debugger.DebugServiceProxy;
	import pl.brun.lib.debugger.Debugger;
	import pl.brun.lib.display.displayObjects.TestBackground;
	import pl.brun.lib.managers.CurrentTime;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.util.func.delayCall;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * Base class for testing.
	 * Offers:
	 *  - debugger
	 *  - "chess background"
	 *  - easy mapping keys to functions
	 * 
	 * 
	 * [SWF(backgroundColor="0xFFFFFF")]
	 * @author Marek Brun
	 */
	public class TestBase extends Sprite {

		protected var dbg:DebugServiceProxy;
		protected var holder:Sprite;
		protected var bg:TestBackground;
		protected var debugHolder:Sprite;
		private var isDebugger:Boolean;
		private var isDarkBG:Boolean;
		private var fps:uint;
		private var isBG:Boolean;
		private var _centerHolder:Sprite;
		protected var loadQueue:ActionsQueue;
		private var keys:KeyCallTester;

		public function TestBase(isDebugger:Boolean = true, isDarkBG:Boolean = false, fps:uint = 40, isBG:Boolean = true) {
			super()
			this.isBG = isBG;
			this.fps = fps;
			this.isDarkBG = isDarkBG;
			this.isDebugger = isDebugger;
			holder = new Sprite();
			_centerHolder = new Sprite()
			//TestUtils.markCenter(_centerHolder)
			// x = 10;
			// y = 10;
			RootProvider.init(this)
			if (stage) {
				delayCall(init, 3);
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onThis_AddedToStage);
			}
		}

		protected function init():void {
			CurrentTime.init(new Date().getTime(), true)
			StageProvider.init(stage);
			if (!(parent is Loader)) {
				stage.frameRate = fps;
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}

			keys = new KeyCallTester()

			debugHolder = new Sprite()
			super.addChild(debugHolder)

			// Debugger.init(debugHolder);
			if (isDebugger) {
				Debugger.init(debugHolder);
			}

			loadQueue = new ActionsQueue()
			//loadQueue.isAutoStart = true

			stage.addEventListener(Event.RESIZE, onStage_Resize, false, 0, true);

			if (!(parent is Loader) && isBG) {
				if (isDarkBG) {
					bg = new TestBackground(40, 0x333333, 0x111111);
				} else {
					bg = new TestBackground(40, 0xFFFFFF, 0xF6F6F6);
				}
				super.addChild(bg);
			}
			super.addChild(holder);
			super.addChild(_centerHolder)
			super.addChild(debugHolder);

			dbg = DebugServiceProxy.forInstance(this);

			delayCall(alignToStage);
			delayCall(loadQueue.start)
			
			start()
		}

		protected function start():void {
			
		}

		override public function removeChild(child:DisplayObject):DisplayObject {
			return holder.removeChild(child);
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			return holder.addChild(child);
		}

		public function addTestKey(keyCode:Number, func:Function, args:Array = null, description:String = null, logPress:Boolean = true):void {
			keys.addTestKey(keyCode, func, args, description, logPress)
		}

		protected function alignToStage():void {
			if (bg) {
				bg.draw(stage.stageWidth, stage.stageHeight);
			}
			centerHolder.x = stage.stageWidth / 2
			centerHolder.y = stage.stageHeight / 2
		}

		public function get centerHolder():Sprite {
			return _centerHolder;
		}

		private function onStage_Resize(event:Event):void {
			alignToStage();
		}

		private function onThis_AddedToStage(event:Event):void {
			init();
		}

		protected function addEventSubscription(obj:IEventDispatcher, type:String, listener:Function):void {
			obj.addEventListener(type, listener)
		}

		protected function removeEventSubscription(obj:IEventDispatcher, type:String, listener:Function):void {
			obj.removeEventListener(type, listener)
		}
		
		
	}
}
