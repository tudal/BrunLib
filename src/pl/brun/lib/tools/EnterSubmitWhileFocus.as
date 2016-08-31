package pl.brun.lib.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.util.KeyCode;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	[Event(name="submit", type="pl.brun.lib.events.EventPlus")]

	/**
	 * @author Marek Brun
	 */
	public class EnterSubmitWhileFocus extends Base {

		public function EnterSubmitWhileFocus(display:DisplayObject, submitButton:Sprite=null) {
			addEventSubscription(display, FocusEvent.FOCUS_IN, onDisplay_FocusIn);
			addEventSubscription(display, FocusEvent.FOCUS_OUT, onDisplay_FocusOut);
			if(submitButton){
				addEventSubscription(submitButton, MouseEvent.CLICK, onSubmit_Click);
			}
		}

		private function onSubmit_Click(event:MouseEvent):void {
			dispatchEvent(new EventPlus(EventPlus.SUBMIT));
		}

		private function onDisplay_FocusOut(event:FocusEvent):void {
			removeEventSubscription(root, KeyboardEvent.KEY_DOWN, onStage_KeyDown_WhileInputFcus);
		}

		private function onDisplay_FocusIn(event:FocusEvent):void {
			addEventSubscription(root, KeyboardEvent.KEY_DOWN, onStage_KeyDown_WhileInputFcus);
		}

		private function onStage_KeyDown_WhileInputFcus(event:KeyboardEvent):void {
			if(event.keyCode == KeyCode.ENTER) {
				dispatchEvent(new EventPlus(EventPlus.SUBMIT));
			}
		}
		
	}
}
