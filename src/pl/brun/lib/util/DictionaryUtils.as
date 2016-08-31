package pl.brun.lib.util {
	import flash.utils.Dictionary;

	/**
	 * created: 2010-01-12
	 * @author Marek Brun
	 */
	public class DictionaryUtils {

		public static function deleteByValue(dict:Dictionary, value:*):void {
			for(var v:* in dict) {
				if(dict[v] == value) {
					delete dict[v];
				}
			}
		}

		public static function arrToDict(arr:Array/*of Object*/, field:String):Dictionary {
			var dict:Dictionary = new Dictionary()
			var obj:Object
			var i:uint
			for(i = 0;i < arr.length;i++) {
				obj = arr[i]
				dict[obj[field]] = obj
			}
			return dict
		}
	}
}
