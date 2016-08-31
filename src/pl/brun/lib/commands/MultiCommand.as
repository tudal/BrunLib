package pl.brun.lib.commands {
	import pl.brun.lib.Base;

	/**
	 * created:2010-11-18  12:45:35
	 * @author Marek Brun
	 */
	public class MultiCommand extends Base implements ICommand {

		private var commands:Array/*of ICommand*/;

		public function MultiCommand(commands:Array/*of ICommand*/) {
			this.commands = commands;
		}

		public function execute():void {
			for each(var command:ICommand in commands) {
				command.execute()
			}
		}
	}
}
