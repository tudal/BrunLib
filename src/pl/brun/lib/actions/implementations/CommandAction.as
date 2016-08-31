package pl.brun.lib.actions.implementations {
	import pl.brun.lib.util.func.delayCall;
	import pl.brun.lib.commands.ICommand;
	import pl.brun.lib.actions.Action;

	/**
	 * @author Jaroslaw Zolnowski
	 */
	public class CommandAction extends Action {
		private var cmd:ICommand;

		public function CommandAction(cmd:ICommand) {
			this.cmd = cmd
		}

		override protected function doRunning():void {
			cmd.execute()
			delayCall(finish)
		}
	}
}
