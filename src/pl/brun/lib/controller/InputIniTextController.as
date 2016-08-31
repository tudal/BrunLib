package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.IValidatable;

	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * created:2010-09-22  14:56:04
	 * @author Marek Brun
	 */
	public class InputIniTextController extends Base implements IValidatable {
		private var iniText:String;
		private var tf:TextField;
		private var htmlHTMLText:String;

		public function InputIniTextController(tf:TextField) {
			this.tf = tf;
			htmlHTMLText = tf.htmlText
			iniText = tf.text;
			tf.addEventListener(FocusEvent.FOCUS_IN, onTF_FocusIn);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onTF_FocusOut);
			tf.addEventListener(Event.CHANGE, onTF_Change);
		}

		public function gotInput():Boolean {
			return tf.text.length && tf.text != iniText;
		}

		public function getInput():String {
			return gotInput() ? tf.text : '';
		}

		public function isValid():Boolean {
			return gotInput();
		}

		// // ////////////////////////////////////////////////////////////////////
		private function onTF_FocusOut(event:FocusEvent):void {
			if (!gotInput()) {
				tf.htmlText = htmlHTMLText;
			}
		}

		private function onTF_FocusIn(event:FocusEvent):void {
			if (!gotInput()) {
				tf.text = '';
			}
		}

		private function onTF_Change(event:Event):void {
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function clear():void {
			tf.htmlText = htmlHTMLText;
		}
	}
}
