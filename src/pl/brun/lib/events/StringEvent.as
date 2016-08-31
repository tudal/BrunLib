package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="submit", type="pl.brun.lib.events.StringEvent")]
	 * 
	 * @author Marek Brun
	 */
	public class StringEvent extends Event {
		
		public static const NEW_DATA:String = 'newData';
		public static const SUBMIT:String = 'submit';
		
		public var string:String;
		
		public function StringEvent(type:String, string:String) {
			super(type);
			this.string = string;
		}
		
		override public function clone():Event {
			return new StringEvent(type, string);
		}
	}
}
