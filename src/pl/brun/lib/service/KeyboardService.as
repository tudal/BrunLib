package pl.brun.lib.service {
	import pl.brun.lib.Base;
	import pl.brun.lib.managers.StageProvider;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	[Event(name="keyUp", type="flash.events.KeyboardEvent")]
	[Event(name="keyDown", type="flash.events.KeyboardEvent")]

	/**
	 * @author Marek Brun
	 */
	public class KeyboardService extends Base {

		public var lastKeyCode:uint;
		public var isAlt:Boolean;
		public var isCtrl:Boolean;
		public var isShift:Boolean;
		private static var instance:KeyboardService;		
		private var dictKeyCode_IsDown:Dictionary = new Dictionary();
		private var antyNoStageFocusTimer:Timer;

		public function KeyboardService(access:ByStaticMethods) {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStage_KeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onStage_KeyUp, false, 0, true);
			stage.addEventListener(Event.DEACTIVATE, onStage_Deactivate, false, 0, true);			stage.addEventListener(FocusEvent.FOCUS_OUT, onStage_FocusOut, false, 0, true);
			
			antyNoStageFocusTimer = new Timer(200, 1);
			antyNoStageFocusTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onAntyNoStageFocusTimer_Complete);
		}

		public static function getIsKeyDown(keyCode:uint):Boolean {
			return getInstance()._getIsKeyDown(keyCode);
		}

		public function _getIsKeyDown(keyCode:uint):Boolean {
			return Boolean(dictKeyCode_IsDown[keyCode]);
		}

		public static function getKeysDown():Array {
			return getInstance()._getKeysDown();
		}

		public function _getKeysDown():Array {
			return dictKeyCode_IsDown.concat();
		}

		public static function isAltDown():Boolean {
			return getInstance().isAlt;
		}

		public static function isCtrlDown():Boolean {
			return getInstance().isCtrl;
		}

		public static function isShiftDown():Boolean {
			return getInstance().isShift;
		}

		public static function getInstance():KeyboardService {
			if(instance) { 
				return instance; 
			} 
			instance = new KeyboardService(null); 
			return instance;
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onStage_KeyDown(event:KeyboardEvent):void {
			if(dictKeyCode_IsDown[event.keyCode]) { 
				return; 
			}
			lastKeyCode = event.keyCode;
			dictKeyCode_IsDown[event.keyCode] = true;
			
			isAlt = event.altKey;			isCtrl = event.ctrlKey;			isShift = event.shiftKey;
			
			dispatchEvent(event.clone());
		}

		private function onStage_KeyUp(event:KeyboardEvent):void {
			if(!dictKeyCode_IsDown[event.keyCode]) { 
				return; 
			}
			dictKeyCode_IsDown[event.keyCode] = false;
			
			isAlt = event.altKey;
			isCtrl = event.ctrlKey;
			isShift = event.shiftKey;
			
			dispatchEvent(event.clone());
		}

		private function onStage_Deactivate(event:Event):void {
			var i:uint;
			var loopIsDown:Boolean;
			for(i = 0;i < dictKeyCode_IsDown.length;i++) {
				loopIsDown = dictKeyCode_IsDown[i];
				if(loopIsDown) {
					dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, false, false, NaN, i));
				}
			}
			dictKeyCode_IsDown = new Dictionary();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onStage_FocusOut(event:FocusEvent):void {
			antyNoStageFocusTimer.reset();
			antyNoStageFocusTimer.start();
		}

		private function onAntyNoStageFocusTimer_Complete(event:TimerEvent):void {
			if(!StageProvider.getStage().focus) {
				StageProvider.getStage().focus = StageProvider.getStage();
			}
		}
	}
}

internal class ByStaticMethods {
}
