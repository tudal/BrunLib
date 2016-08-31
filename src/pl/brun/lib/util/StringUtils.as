package pl.brun.lib.util {

	/**
	 * @author Marek Brun
	 */
	public class StringUtils {

		public static function literal(str:String):String {
			var meta:Array = '.+?*^$()\|{}'.split('');
			var i:uint;
			var loopMeta:String;
			for(i = 0;i < meta.length;i++) {
				loopMeta = meta[i];
				str = str.split(loopMeta).join('[' + loopMeta + ']');
			}
			str = str.split('[').join('\[');
			str = str.split(']').join('\]');
			return str;
		}

		public static function getBetweens(str:String, startRegex:String, endRegex:String):Array {
			var i:uint;
			var finds:Array = str.match(new RegExp(startRegex + '(.*?)' + endRegex, 'gm'));
			var find:String;
			for(i = 0;i < finds.length;i++) {
				find = finds[i];
				find = find.replace(new RegExp(startRegex, ''), '');
				find = find.replace(new RegExp(endRegex, ''), '');
				finds[i] = find;
			}
			return finds;
		}

		public static function frontZero(digitSum:Number, number:Number):String {
			var str:String = String(int(number));
			var len:Number = digitSum - str.length + 1;
			var summStr:Array = [];
			var i:uint;
			for(i = 1;i < len;i++) { 
				summStr.push('0'); 
			}
			return summStr.join('') + str;
		}

		public static function safeHTML(str:String):String {
			return str.split('<').join('&lt;').split('>').join('&gt;');
		}

		public static function multiply(str:String, length:Number):String {
			var resultStr:String = '';
			for(var i:uint = 0;i < length;i++) { 
				resultStr += str; 
			}
			return resultStr;
		}

		public static function formatDateDDMMYYYY(date:Date, delimiter:String = '.'):String {
			return StringUtils.frontZero(2, date.getDate()) + delimiter + StringUtils.frontZero(2, date.getMonth() + 1) + delimiter + date.getFullYear();
		}

		public static function formatTimeMMSS(time:Number, delimiter:String = ':'):String {
			return StringUtils.frontZero(2, time / 60000) + delimiter + StringUtils.frontZero(2, (time % 60000) / 1000);
		}

		public static function firstBig(str:String):String {
			return str.substr(0, 1).toUpperCase() + str.substr(1).toLowerCase();
		}

		public static function formatDecimals(num:Number, digits:uint):String {
			var tenToPower:Number = Math.pow(10, digits);
			var cropped:String = String(Math.round(num * tenToPower) / tenToPower);
			
			var decimalPosition:int;
			
			for(var i:int = 0;i < cropped.length;i++) {
				if (cropped.charAt(i) == ".") {
					decimalPosition = i;
				}
			}
			
			var output:String = cropped;
			var decimals:String = cropped.substr(decimalPosition + 1, cropped.length);
			var missingZeros:Number = digits - decimals.length;
			
			if (decimals.length < digits && decimalPosition > 0) {
				for (var j:int = 0;j < missingZeros; j++) {
					output += "0";
				}
			}
					
			return output;
		}

		public static function isValidEmail(email:String):Boolean {    
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
	}
}
