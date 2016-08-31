package pl.brun.lib.events {
	import flash.utils.ByteArray;
	import flash.events.Event;

	/**
	 * [Event(name="newData", type="pl.brun.lib.events.ByteArrayEvent")]
	 * 
	 * @author Marek Brun
	 */
	public class ByteArrayEvent extends Event {
		public static const NEW_BIN_DATA:String = 'newBinData';
		public static const SUBMIT:String = 'submit';
		public var ba:ByteArray;

		public function ByteArrayEvent(type:String, ba:ByteArray) {
			super(type)
			this.ba = ba
		}
	}
}
