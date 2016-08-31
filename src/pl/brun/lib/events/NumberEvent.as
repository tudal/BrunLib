package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="select", type="pl.brun.lib.events.NumberEvent")]
	 * 
	 * NumberEvent.SELECT
	 * 
	 * 
	 * created: 2012-03-29
	 * @author Jaroslaw Zolnowski
	 */
	public class NumberEvent extends Event {

		public static const SELECT:String = 'select';
		
		public var number:Number;

		public function NumberEvent(type:String, number:Number) {
			super(type);
			this.number = number;
		}

		override public function clone():Event {
			return new NumberEvent(type, number);
		}
	}
}

