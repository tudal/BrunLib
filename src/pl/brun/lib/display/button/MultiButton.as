package pl.brun.lib.display.button {
	import pl.brun.lib.models.MultiBoolean;

	import flash.events.Event;

	/**
	 * Merge behaviour of couple buttons in one.
	 * 
	 * Suport only over->out events.
	 * 
	 * There's 2 frames delay betwen one of registered buttons "out"
	 * event and actual MultiButton out event - in this time "over"
	 * from another button can be registered.
	 * 
	 * @author Marek Brun
	 */
	public class MultiButton extends ButtonModel {

		private var isMultiOver:MultiBoolean;
		private var outCount:int;

		public function MultiButton() {
			isMultiOver = new MultiBoolean();
			isMultiOver.addEventListener(Event.CHANGE, onIsMultiOver_Change);
		}

		public function registerButton(button:ButtonModel):void {
			button.addEventListener(ButtonEvent.OVER, onButton_Over);
			button.addEventListener(ButtonEvent.OUT, onButton_Out);		}

		private function startCountingToOut():void {
			outCount = 2;
			addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileOut);
		}
		
		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onButton_Over(event:ButtonEvent):void {
			isMultiOver.setIsTrue(event.target, true);
		}

		private function onButton_Out(event:ButtonEvent):void {
			isMultiOver.setIsTrue(event.target, false);
		}

		private function onIsMultiOver_Change(event:Event):void {
			if(isMultiOver.value) {
				removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileOut);
				rollOver();
			} else {
				startCountingToOut();
			}
		}

		private function onStage_EnterFrame_WhileOut(event:Event):void {
			outCount--;
			if(!outCount) {
				removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame_WhileOut);
				rollOut();
			}
		}
	}
}
