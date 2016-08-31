package pl.brun.lib.commands {

	/**
	 * @author Marek Brun
	 */
	public class UintSignal extends Signal {
		public var value:uint;

		public function createCommand(value:uint):ICommand {
			return new Cmd(this, value)
		}
	}
}
import pl.brun.lib.commands.ICommand;
import pl.brun.lib.commands.UintSignal;

class Cmd implements ICommand {
	private var value:uint;
	private var signal:UintSignal;

	public function Cmd(signal:UintSignal, value:uint) {
		this.signal = signal;
		this.value = value;
	}

	public function execute():void {
		signal.value = value
		signal.execute()
	}
}