package pl.brun.lib.tools {
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class URLLoaderPlusEvent extends Event {
		public static const FINISH:String = 'finish';
		public static const FAIL:String = 'fail';
		public static const CANT_LOAD:String = 'cantLoad';
		public static const COMPLETE:String = 'complete';

		public function URLLoaderPlusEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
