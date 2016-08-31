package pl.brun.lib.util {
	import flash.errors.IllegalOperationError;

	/**
	 * @author Marek Brun
	 */
	public class VectorUtils {

		private static var sortField:String;

		private static function swap(vect:Object, a:uint, b:uint):void {
			var temp:Object = vect[a];
			vect[a] = vect[b];
			vect[b] = temp;
		}

		private static function shuffleSort(vect:Object):void {
			var totalItems:uint = vect.length;
			for (var i:uint = 0; i < totalItems; i++) {
				swap(vect, i, i + uint(Math.random() * (totalItems - i)));
			}
		}

		public static function shuffle(vect:*):void {
			shuffleSort(vect)
		}

		public static function remove(vect:*, value:*):Boolean {
			var i:uint, isRemove:Boolean;
			while ((i = vect.indexOf(value)) != -1) {
				isRemove = true;
				vect.splice(i, 1);
			}
			return isRemove;
		}

		public static function sortOn(vect:*, field:String):void {
			if(vect is Array){
				throw new IllegalOperationError('array not vector')
			}
			sortField = field
			vect.sort(sortDesc)
		}

		private static function sortDesc(p1:Object, p2:Object):Number {
			var p1v:* = p1[sortField]
			var p2v:* = p2[sortField]
			if (p1v > p2v) {
				return 1;
			} else if (p1v < p2v) {
				return -1;
			}
			return 0;
		}

		public static function numberSearchOn(vect:*, fieldName:String, target:Number, putObject:Object = null):uint {
			var count:uint = 1

			if (target <= vect[0][fieldName]) {
				if (putObject) vect.unshift(putObject);
				return 0;
			} else if (target >= vect[vect.length - 1][fieldName]) {
				if (putObject) vect.push(putObject);
				return vect.length - 1;
			}

			var i:uint = 0
			var v:Number
			var isUp:Boolean = true
			var len:uint = vect.length / 2
			var maxiter:uint = 10000
			while (maxiter--) {
				count++
				if (isUp) {
					i = Math.min(vect.length - 1, i + len)
					v = vect[i][fieldName]
					if (v > target) {
						if (vect[i - 1][fieldName] <= target) {
							if (putObject) vect.splice(i, 0, putObject);
							return i
						}
						len = Math.max(1, len / 2)
						isUp = false
					}
				} else {
					i = Math.max(0, i - len)
					v = vect[i][fieldName]
					if (v < target) {
						if (vect[i + 1][fieldName] >= target) {
							if (putObject) vect.splice(i + 1, 0, putObject);
							return i + 1
						}
						len = Math.max(1, len / 2)
						isUp = true
					}
				}
			}
			throw new IllegalOperationError("Index for number " + target + " not found")
		}

		public static function getRandom(arr:*):* {
			return arr[getRandomIndex(arr)];
		}

		public static function getRandomIndex(arr:*):uint {
			return Math.round(Math.random() * (arr.length - 1));
		}
	}
}
