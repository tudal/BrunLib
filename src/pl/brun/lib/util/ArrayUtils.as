/*
 * Copyright 2009 Marek Brun
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *    
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package pl.brun.lib.util {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	/**
	 * @author Marek Brun
	 */
	public class ArrayUtils {
		public static function shuffle(arr:Array):Array {
			var arr2:Array = [];
			arr = arr.concat();
			while (arr.length) {
				arr2.push(arr.splice(Math.round(Math.random() * arr.length - 1), 1)[0]);
			}
			return arr2;
		}

		public static function remove(arr:Array, value:*):Boolean {
			var i:uint, isRemove:Boolean;
			while ((i = arr.indexOf(value)) != -1) {
				isRemove = true;
				arr.splice(i, 1);
			}
			return isRemove;
		}

		/**
		 * Moving items in array
		 * ex.
		import pl.brun.lib.util.ArrayUtil;
		var arr:Array=[0,1,2,3,4,5,6,7,8,9];
		MLArrayUtil.move(arr, 3); trace(arr); // output:7,8,9,0,1,2,3,4,5,6
		MLArrayUtil.move(arr, -3); trace(arr); // output:0,1,2,3,4,5,6,7,8,9
		MLArrayUtil.move(arr, -3); trace(arr); // output:3,4,5,6,7,8,9,0,1,2
		 */
		public static function moveAll(arr:Array, positions:int):void {
			if (positions > 0) {
				positions = positions % arr.length;
				while (positions--) {
					arr.unshift(arr.pop());
				}
			} else if (positions < 0) {
				positions = -positions;
				positions = positions % arr.length;
				while (positions--) {
					arr.push(arr.shift());
				}
			}
		}

		public static function getArrayByObjProp(arr:Array, objectProp:*):Array {
			var i:Number = arr.length;
			var byObj:Array = [];
			while (--i - (-1)) {
				byObj.push(arr[i][objectProp]);
			}
			return byObj;
		}

		public static function getWhereObjProp(arr:Array, objectPropName:*, value:*):* {
			return arr[getIndexWhereObjProp(arr, objectPropName, value)];
		}

		public static function getIndexWhereObjProp(arr:Array, objectPropName:String, value:*):Number {
			var i:Number = arr.length;
			while (--i - (-1)) {
				if (arr[i].hasOwnProperty(objectPropName) && arr[i][objectPropName] == value) {
					return i;
					break;
				}
			}
			return NaN;
		}

		public static function getObjWhereObjProp(arr:Array, objectPropName:String, value:*):Number {
			return arr[getIndexWhereObjProp(arr, objectPropName, value)];
		}

		public static function getWhereObjsProp(arr:Array, objectPropName:*, value:*):Array {
			var i:Number = arr.length;
			var founds:Array = [];
			while (--i - (-1)) {
				if (arr[i].hasOwnProperty(objectPropName) && arr[i][objectPropName] == value) {
					founds.push(arr[i]);
				}
			}
			return founds;
		}

		public static function getWhereObjsPropNot(arr:Array, objectPropName:*, value:*):Array {
			var i:Number = arr.length;
			var founds:Array = [];
			while (--i - (-1)) {
				if (arr[i][objectPropName] != value) {
					founds.push(arr[i]);
				}
			}
			return founds;
		}

		public static function getWhereObjsOneOfProps(arr:Array, objectPropName:String, values:Array):Array {
			var i:Number = arr.length;
			var founds:Array = [];
			var p:uint;
			while (--i - (-1)) {
				for (p = 0;p < values.length;p++) {
					if (arr[i].hasOwnProperty(objectPropName) && arr[i][objectPropName] == values[p]) {
						founds.push(arr[i]);
						break;
					}
				}
			}
			return founds;
		}

		public static function getWhereObjsPropNumberBetween(arr:Array, objectPropName:String, betweenIni:Number, betweenEnd:Number):Array {
			var i:Number = arr.length;
			var founds:Array = [];
			while (--i - (-1)) {
				if (arr[i].hasOwnProperty(objectPropName) && arr[i][objectPropName] >= betweenIni && arr[i][objectPropName] <= betweenEnd) {
					founds.push(arr[i]);
				}
			}
			return founds;
		}

		public static function getByProp(arr:Array, propNumOrName:Object):Array {
			var byProp:Array = [];
			for (var i:uint = 0;i < arr.length;i++) {
				byProp[arr[i][propNumOrName]] = arr[i];
			}
			return byProp;
		}

		public static function getNextByValue(arr:Array, value:*):* {
			return arr[getNextIndexByValue(arr, value)];
		}

		public static function getPrevByValue(arr:Array, value:*):* {
			return arr[getPrevIndexByValue(arr, value)];
		}

		public static function getNextIndexByValue(arr:Array, value:*):uint {
			return getNextIndex(arr, arr.indexOf(value));
		}

		public static function getNextIndex(arr:Array, index:uint):uint {
			if (index == arr.length - 1) {
				return 0;
			}
			return index + 1;
		}

		public static function getPrevIndexByValue(arr:Array, value:*):uint {
			return getPrevIndex(arr, arr.indexOf(value))
		}

		public static function getPrevIndex(arr:Array, index:uint):uint {
			if (index == 0) {
				return arr.length - 1;
			}
			return index - 1;
		}

		public static function getByTurn(arr:Array, value:*, turn:Number):Object {
			if (turn > 0) {
				return getNextByValue(arr, value);
			} else {
				return getPrevByValue(arr, value);
			}
		}

		public static function got(arr:Array, value:*):Boolean {
			return arr.indexOf(value) != -1;
		}

		public static function gotObjVar(arr:Array, varName:String, value:*):Boolean {
			for (var i:uint = 0;i < arr.length;i++) {
				if (arr[i][varName] === value) {
					return true;
				}
			}
			return false;
		}

		public static function pushUnique(arr:Array, value:*):Boolean {
			if (arr.indexOf(value) == -1) {
				arr.push(value);
				return true;
			}
			return false;
		}

		public static function removeValues(arr:Array, toRemoves:Array):void {
			for (var i:uint = 0;i < toRemoves.length;i++) {
				remove(arr, toRemoves[i]);
			}
		}

		public static function applyProps(arr:Array, propName:String, value:*):void {
			var len:uint = arr.length;
			for (var i:uint = 0;i < len;i++) {
				arr[i][propName] = value;
			}
		}

		public static function divideToParts(arr:Array, parts:Number):Array {
			var partsArr:Array = [];
			arr = arr.concat();
			var partLength:Number = int(arr.length / parts);
			for (var i:uint = 0;i < parts;i++) {
				partsArr.push(arr.splice(0, partLength));
			}

			return partsArr;
		}

		public static function getRandom(arr:Array):* {
			return arr[getRandomIndex(arr)];
		}

		public static function removeRandom(arr:Array):* {
			var index:uint = getRandomIndex(arr);
			return arr.splice(index, 1)[0];
		}

		public static function getRandomIndex(arr:Array):uint {
			return Math.round(Math.random() * (arr.length - 1));
		}

		public static function pushAfter(arr:Array, inArrBefore:*, toPushAfter:*):void {
			if (!got(arr, inArrBefore)) {
				throw new IllegalOperationError('can\'t find inArrBefore:' + inArrBefore);
				return;
			}
			var inArrIndex:uint = arr.indexOf(inArrBefore);
			if (inArrIndex == arr.length - 1) {
				arr.push(toPushAfter);
			} else {
				var restArr:Array = arr.splice(inArrIndex + 1);
				arr.push(toPushAfter);
				arr.push.apply(arr, restArr);
			}
		}

		public static function pushBefore(arr:Array, inArrAfter:*, toPushBefore:*):void {
			if (!got(arr, inArrAfter)) {
				throw new IllegalOperationError('can\'t find inArrAfter:' + inArrAfter);
				return;
			}
			var inArrIndex:uint = arr.indexOf(inArrAfter);
			if (inArrIndex == 0) {
				arr.unshift(toPushBefore);
			} else {
				var restArr:Array = arr.splice(inArrIndex);
				arr.push(toPushBefore);
				arr.push.apply(arr, restArr);
			}
		}

		public static function insertArray(base:Array, startIndex:uint, toInsert:Array):void {
			while (toInsert.length) {
				base.splice(startIndex, 0, toInsert.pop());
			}
		}

		public static function createArrayByDictionaryValues(dict:Dictionary):Array {
			var arr:Array = [];
			for (var n:* in dict) {
				arr.push(dict[n]);
			}
			return arr;
		}

		public static function move(arr:Array, toMove:*, targetIndex:uint):void {
			if (arr.indexOf(toMove) == -1) {
				throw new IllegalOperationError('Can\'t find passed value');
			}
			arr.splice(arr.indexOf(toMove), 1)[0];
			if (targetIndex == 0) {
				arr.unshift(toMove);
			} else if (targetIndex > arr.length - 1) {
				arr.push(toMove);
			} else {
				arr.splice(targetIndex, null, toMove);
			}
		}

		public static function clear(arr:Array):void {
			while (arr.length) {
				arr.pop()
			}
		}
	}
}
