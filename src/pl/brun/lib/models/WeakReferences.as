package pl.brun.lib.models {
	import pl.brun.lib.Base;

	import flash.utils.Dictionary;

	/**
	 * created: 2009-12-27
	 * @author Marek Brun
	 */
	public class WeakReferences extends Base {

		private var countValues:uint;
		private var dict:Dictionary = new Dictionary(true);

		public function WeakReferences() {
		}

		public function getID(value:Object):uint {
			if(!dict[value]) {
				countValues++;
				dict[value] = countValues;
			}
			return dict[value];
		}

		public function getValue(id:uint):* {
			for(var v:* in dict){
				if(dict[v]==id){
					return v;
				}
			}
			return null;
		}
	}
}
