package pl.brun.lib.display.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.models.IDisplayObjectOperator;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Marek Brun
	 */
	public class CustomDisplayActionAdder extends Base {

		private var holder:DisplayObjectContainer;
		
		public function CustomDisplayActionAdder(holder:DisplayObjectContainer) {
			this.holder = holder;
		}

		public function registerAction(action:Action):void {
			if(!(action is IDisplayObjectOperator)){
				throw new ArgumentError('Passed \'action\' must implement IDisplayObjectOperator');
			}
			action.addEventListener(ActionEvent.RUNNING_START, onAction_RunningStart);
		}
		
		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onAction_RunningStart(event:ActionEvent):void {
			Action(event.target).addEventListener(ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
			holder.addChild(IDisplayObjectOperator(event.target).display);
		}

		private function onAction_RunningFinish_WhileAdded(event:ActionEvent):void {
			Action(event.target).removeEventListener(ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
			holder.removeChild(IDisplayObjectOperator(event.target).display);
		}
	}
}
