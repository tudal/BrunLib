package pl.brun.lib.actions.controllers {
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ChildActionEvent;

	/**
	 * @author Marek Brun
	 */
	public class NoChildRunAutoFinishCtrl extends Base {
		
		private var action:Action;

		public function NoChildRunAutoFinishCtrl(action:Action) {
			this.action = action
			action.addEventListener(ChildActionEvent.CHILD_ACTION_RUNNING_FINISH, onAction_ChildActionRunningFinish)
		}

		private function onAction_ChildActionRunningFinish(event:ChildActionEvent):void {
			if(!action.gotAnyChildToRun()){
				action.finish()
			}
		}
	}
}
