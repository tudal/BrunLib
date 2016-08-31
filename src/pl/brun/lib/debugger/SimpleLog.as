package pl.brun.lib.debugger {
	import pl.brun.lib.display.DisplayBase;

	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Marek Brun
	 */
	public class SimpleLog extends DisplayBase {
		private static var instance:SimpleLog;
		private var tf:TextField;
		private var parent:DisplayObjectContainer;
		private var logs:Array = [];

		public function SimpleLog(parent:DisplayObjectContainer) {
			this.parent = parent
			tf = new TextField()
			container.addChild(tf)
			tf.width = 300
			tf.height = stage.stageHeight / 2
			tf.wordWrap = false

			tf.addEventListener(MouseEvent.MOUSE_DOWN, onTF_MouseDown)
		}

		private function onTF_MouseDown(event:MouseEvent):void {
			if (tf.height < 30) {
				tf.height = stage.stageHeight / 2
			} else {
				tf.height = 20
			}
		}

		private function log_(text:String):void {
			logs.push(text)
			while (logs.length > 100) {
				logs.shift()
			}
			tf.htmlText = logs.splice('\n')
			tf.width = tf.textWidth
			tf.scrollV = tf.maxScrollV
			parent.addChild(d)
		}

		public static function log(text:String):void {
			if(!instance) return;
			instance.log_(text)
		}

		public static function init(parent:DisplayObjectContainer):void {
			if (instance) {
				throw new IllegalOperationError('already initialized')
			}
			instance = new SimpleLog(parent)
		}

		public static function ins():SimpleLog {
			if (!instance) {
				throw new IllegalOperationError('call init first')
			}
			return instance
		}
	}
}
