package pl.brun.lib.test {
	import pl.brun.lib.Base;
	import pl.brun.lib.commands.ICommand;

	/**
	 * @author Marek Brun
	 */
	public class LogCommand extends Base implements ICommand {

		private var logText:String;
		
		public function LogCommand(logText:String) {
			this.logText = logText;
		}
		
		public function execute():void {
			dbg.log(logText);
		}
	}
}
