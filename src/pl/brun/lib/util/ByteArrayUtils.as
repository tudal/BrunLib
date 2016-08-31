package pl.brun.lib.util {
	import flash.utils.ByteArray;

	/**
	 * @author Marek Brun
	 */
	public class ByteArrayUtils {
		
		public static function readablizeBytes(bytes:uint):String {
			var s:Array = ['bytes', 'kb', 'MB', 'GB', 'TB', 'PB'];
			var e:Number = Math.floor(Math.log(bytes) / Math.log(1024));
			return ( bytes / Math.pow(1024, Math.floor(e)) ).toFixed(2) + " " + s[e];
		}

		public static function writeCompressedObject(ba:ByteArray, saveObj:Object):void {
			ba.clear()
			ba.writeObject(saveObj)
			ba.position = 0
			ba.compress()
			ba.position = 0
		}

		public static function readCompressedObject(ba:ByteArray):* {
			ba.position = 0
			ba.uncompress()
			ba.position = 0
			return ba.readObject()
		}

		public static function writeObject(ba:ByteArray, saveObj:Object):void {
			ba.clear()
			ba.writeObject(saveObj)
			ba.position = 0
		}

		public static function readObject(ba:ByteArray):* {
			ba.position = 0
			return ba.readObject()
		}

		public static function clone(source:ByteArray, destination:ByteArray):void {
			destination.clear()
			destination.writeBytes(source)
		}
	}
}
