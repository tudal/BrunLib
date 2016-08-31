package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class ObjectEvent extends Event {
		
		public static const NEW_DATA:String = "newData";
		
		public var obj:Object;

		public function ObjectEvent(type:String, obj:Object) {
			super(type)
			this.obj = obj;
		}
		
		override public function clone():Event {
			return new ObjectEvent(type, obj);
		}
	}
}
