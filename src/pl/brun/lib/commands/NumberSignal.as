package pl.brun.lib.commands {

	/**
	 * @author Marek Brun
	 */
	public class NumberSignal extends Signal {
		public var value:Number;

		public function createCommand(value:Number):ICommand {
			return new Cmd(this, value)
		}
	}
}
import pl.brun.lib.commands.ICommand;
import pl.brun.lib.commands.NumberSignal;

class Cmd implements ICommand {
	private var value:Number;
	private var signal:NumberSignal;

	public function Cmd(signal:NumberSignal, value:Number) {
		this.signal = signal;
		this.value = value;
	}

	public function execute():void {
		signal.value = value
		signal.execute()
	}
}