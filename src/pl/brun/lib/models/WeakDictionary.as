package pl.brun.lib.models {
	import pl.brun.lib.Base;

	import flash.utils.Dictionary;

	/**
	 * 03-08-2012
	 * @author Marek Brun
	 */
	public class WeakDictionary  extends Base {
		private var dict:Dictionary = new Dictionary(true);

		public function WeakDictionary(name:String) {
			dbg.logvID = ' weak'
			dbg.logvID2 = name
		}

		public function put(value:Object, id:*):void {
			dict[value] = id
		}

		public function remove(value:Object):void {
			if (dict[value]) delete dict[value];
		}

		public function getValue(id:*):Object {
			// var count:int = 0
			for (var v:* in dict) {
				// count++
				if (dict[v] == id) {
					return v;
				}
			}
			// dbg.logv('count', count)
			return null;
		}
	}
}
