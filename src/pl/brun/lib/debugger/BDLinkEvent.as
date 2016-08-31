package pl.brun.lib.debugger {
	import flash.events.Event;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDLinkEvent extends Event {

		public static const LINK_CALL:String = 'linkCall';
		public var link:BDLinkVO;

		public function BDLinkEvent(type:String, link:BDLinkVO, bubbles:Boolean = false, cancelable:Boolean = false) {
			this.link = link;
			super(type, bubbles, cancelable);
		}
	}
}
