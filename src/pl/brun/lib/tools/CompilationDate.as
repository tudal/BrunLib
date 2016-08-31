package pl.brun.lib.tools {
	import pl.brun.lib.util.func.timeAgo;
	import pl.brun.lib.Base;

	import flash.display.LoaderInfo;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * Direct reading of SWF file
	 * Distributed under the new BSD License
	 * @author Paul Sivtsov - ad@ad.by
	 */
	public class CompilationDate extends Base {

		public static function ago(docClassLoaderInfo:LoaderInfo):String {
			try {
				var date:Date = read(docClassLoaderInfo)
				var dateNow:Date = new Date()
				return 'created ' + timeAgo(dateNow.getTime() - date.getTime())
			}catch(error:Error){
				return "(no metadata)"
			}
			return "(no metadata)"
		}

		public static function read(docClassLoaderInfo:LoaderInfo, serialNumber:ByteArray = null):Date {
			const compilationDate:Date = new Date;
			const DATETIME_OFFSET:uint = 18;

			if (serialNumber == null) {
				serialNumber = readSerialNumber(docClassLoaderInfo);
			}
			
			if (serialNumber == null) {
				return null;
			}
			
			serialNumber.position = DATETIME_OFFSET;
			serialNumber.endian = Endian.LITTLE_ENDIAN;
			compilationDate.time = serialNumber.readUnsignedInt() + serialNumber.readUnsignedInt() * (uint.MAX_VALUE + 1);

			return compilationDate;
		}

		public static function readSerialNumber(loaderInfo:LoaderInfo):ByteArray {
			const TAG_SERIAL_NUMBER:uint = 0x29;
			return findAndReadTagBody(TAG_SERIAL_NUMBER, loaderInfo);
		}

		public static function findAndReadTagBody(theTagCode:uint,loaderInfo:LoaderInfo):ByteArray {
			var li:LoaderInfo = loaderInfo;
			const src:ByteArray = li.bytes;
			
			src.position = 8;
			const RECT_UB_LENGTH:uint = 5;
			const RECT_SB_LENGTH:uint = src.readUnsignedByte() >> (8 - RECT_UB_LENGTH);
			const RECT_LENGTH:uint = Math.ceil((RECT_UB_LENGTH + RECT_SB_LENGTH * 4) / 8);
			src.position += (RECT_LENGTH - 1);
			// skip FrameRate & FrameCount
			src.position += 4;

			while (src.bytesAvailable > 0) {
				with (readTag(src, theTagCode)) {
					if (tagCode == theTagCode) {
						return tagBody;
					}
				}
			}
			
			return null;
		}

		private static function readTag(src:ByteArray, theTagCode:uint):Object {
			src.endian = Endian.LITTLE_ENDIAN;
			
			const tagCodeAndLength:uint = src.readUnsignedShort();
			const tagCode:uint = tagCodeAndLength >> 6;
			const tagLength:uint = function(): uint {
				const MAX_SHORT_TAG_LENGTH:uint = 0x3F;
				const shortLength:uint = tagCodeAndLength & MAX_SHORT_TAG_LENGTH;
				return (shortLength == MAX_SHORT_TAG_LENGTH) ? src.readUnsignedInt() : shortLength;
			}();

			const tagBody:ByteArray = new ByteArray;
			if (tagLength > 0) {
				src.readBytes(tagBody, 0, tagLength);
			}

			return {tagCode: tagCode, tagBody: tagBody};
		}
	}
}