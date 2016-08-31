package pl.brun.lib.display.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.ChildActionEvent;
	import pl.brun.lib.models.IDisplayObjectOperator;

	import flash.display.DisplayObjectContainer;

	/**
	 * Automatically adds to children-actions display to passed holder. 
	 * 
	 * @author Marek Brun
	 */
	public class AutoDisplayActionAdder extends Base {

		private var holder:DisplayObjectContainer;

		public function AutoDisplayActionAdder(holder:DisplayObjectContainer, action:Action) {
			this.holder = holder;
			addEventSubscription(action, ChildActionEvent.CHILD_ACTION_RUNNING_START, onAction_ChildActionRunningStart);
			action.addDisposeChild(this);
		}

		override public function dispose():void {
			holder = null;
			super.dispose();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onAction_ChildActionRunningStart(event:ChildActionEvent):void {
			if(event.child is IDisplayObjectOperator) {
				addEventSubscription(event.child, ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
				holder.addChild(IDisplayObjectOperator(event.child).display);
			}
		}

		private function onAction_RunningFinish_WhileAdded(event:ActionEvent):void {
			removeEventSubscription(Action(event.target), ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
			holder.removeChild(IDisplayObjectOperator(event.target).display);
		}
	}
}
