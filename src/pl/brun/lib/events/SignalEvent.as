package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="signal", type="pl.brun.lib.events.SignalEvent")]
	 * 
	 * @author Marek Brun
	 */
	public class SignalEvent extends Event {

		public static const SIGNAL:String = 'signal';
		
		public function SignalEvent(type:String) {
			super(type);
		}
	}
}
