package pl.brun.lib.display.displayObjects {
	import flash.events.Event;

	/**
	 * [Event(name="addedChild", type="pl.brun.lib.display.displayObjects.OneDisplayContainerEvent")]
	 * [Event(name="removedChild", type="pl.brun.lib.display.displayObjects.OneDisplayContainerEvent")]
	 * @author Marek Brun
	 */
	public class OneDisplayContainerEvent extends Event {
		
		public static const ADDED_CHILD:String='addedChild';
				public static const REMOVED_CHILD:String='removedChild';
		
		public function OneDisplayContainerEvent(type:String) {
			super(type);
		}
		
	}
}
