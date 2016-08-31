package pl.brun.lib.commands {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.SignalEvent;

	[Event(name="signal", type="pl.brun.lib.events.SignalEvent")]
	/**
	 * @author Marek Brun
	 */
	public class Signal extends Base implements ICommand {
		private var _isEnabled:Boolean = true;

		public function Signal() {
		}

		public function execute():void {
			if(isEnabled){
				dispatchEvent(new SignalEvent(SignalEvent.SIGNAL))
			}
		}

		public function get isEnabled():Boolean {
			return _isEnabled;
		}

		public function set isEnabled(isEnabled:Boolean):void {
			_isEnabled = isEnabled
		}
	}
}
