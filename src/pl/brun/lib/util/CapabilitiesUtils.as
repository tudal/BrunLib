package pl.brun.lib.util {
	import flash.system.Capabilities;

	/**
	 * @author Marek Brun
	 */
	public class CapabilitiesUtils {

		public static function isIOS():Boolean {
			var os:String = Capabilities.os.toLowerCase()
			return os.indexOf('mac') > -1 || os.indexOf('iphone') > -1 || os.indexOf('ipad') > -1
		}

		public static function isAir():Boolean {
			return Capabilities.playerType == "Desktop"
		}
	}
}
