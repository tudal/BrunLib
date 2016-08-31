package pl.brun.lib.commands {

	/**
	 * @author Marek Brun
	 */
	public class CallCmd implements ICommand {

		private var func:Function;
		private var args:Array/*of * */;

		public function CallCmd(func:Function, args:Array/*of * */=null) {
			this.args = args;
			this.func = func;
		}
		
		public function execute():void {
			func.apply(undefined, args);
		}
	}
}
