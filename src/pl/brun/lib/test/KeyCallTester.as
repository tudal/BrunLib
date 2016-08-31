package pl.brun.lib.test {
	import pl.brun.lib.Base;
	import pl.brun.lib.util.KeyEN;

	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;

	public class KeyCallTester extends Base {
		private static var instance:KeyCallTester;
		/*uint and Function*/
		private var dictKeyCode_TestKey:Dictionary = new Dictionary();

		public function KeyCallTester() {
			addEventSubscription(stage, KeyboardEvent.KEY_DOWN, onStage_KeyDown, false, 0, true);
		}

		public function addTestKey(keyCode:Number, func:Function, args:Array = null, description:String = null, logPress:Boolean = true):void {
			var testKey:TestKey = new TestKey(keyCode, func, args, description, logPress)
			if (!dictKeyCode_TestKey[keyCode]) {
				dictKeyCode_TestKey[keyCode] = []
			}
			dictKeyCode_TestKey[keyCode].push(testKey);
			if (description) {
				dbg.log('added test key <b>' + KeyEN.getKeyName(keyCode) + '</b> - ' + description);
			} else {
				dbg.log('added test key <b>' + KeyEN.getKeyName(keyCode) + '</b>');
			}
		}

		private function onStage_KeyDown(event:KeyboardEvent):void {
			if (root.stage.focus is TextField && TextField(root.stage.focus).type == TextFieldType.INPUT) {
				return
			}
			if (dictKeyCode_TestKey[event.keyCode]) {
				var keyCodes:Array /*of TestKey*/ 
				= dictKeyCode_TestKey[event.keyCode]
				var i:uint;
				var testKey:TestKey
				for (i = 0;i < keyCodes.length;i++) {
					testKey = keyCodes[i]
					if (testKey.logPress) {
						dbg.log('call of test key <b>' + KeyEN.getKeyName(event.keyCode) + '</b> ' + testKey.description);
					}
					if (testKey.args) {
						testKey.func.apply(null, testKey.args)
					} else {
						testKey.func()
					}
				}
			}
		}

		public static function ins():KeyCallTester {
			if (!instance) {
				instance = new KeyCallTester()
			}
			return instance
		}
	}
}
class TestKey {
	public var keyCode:Number;
	public var func:Function;
	public var args:Array;
	public var description:String;
	public var logPress:Boolean;

	public function TestKey(keyCode:Number, func:Function, args:Array = null, description:String = null, logPress:Boolean = true) {
		this.logPress = logPress;
		this.description = description || "";
		this.args = args;
		this.func = func;
		this.keyCode = keyCode;
	}
}
