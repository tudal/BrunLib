package pl.brun.lib.events {
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * [Event(name="newMc", type="pl.brun.lib.events.DisplayEvent")]
	 * @author Marek Brun
	 */
	public class DisplayEvent extends Event {
		
		public static const NEW_MC:String = "newMc";
		
		public var display:DisplayObject;

		public function DisplayEvent(type:String, display:DisplayObject) {
			super(type);
			this.display = display;
		}
	}
}
