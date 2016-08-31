package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="ready", type="pl.brun.lib.events.BooleanEvent")]
	 * 2011-03-23  21:54:53
	 * @author Marek Brun
	 */
	public class BooleanEvent extends Event {

		public static const READY:String = "ready";
		
		public var result:Boolean;
		
		public function BooleanEvent(type:String, result:Boolean) {
			super(type)
			this.result = result
		}
	}
}
