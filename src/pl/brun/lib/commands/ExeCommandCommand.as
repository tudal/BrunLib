package pl.brun.lib.commands {
	import pl.brun.lib.Base;

	/**
	 * @author Marek Brun
	 */
	public class ExeCommandCommand extends Base implements ICommand {
		
		public var command:ICommand;
		
		public function execute():void {
			command.execute();
		}
		
	}
}
