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
package pl.brun.lib.models {
	import pl.brun.lib.Base;

	import flash.events.Event;
	import flash.utils.Dictionary;

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * If "true" count is 0 then value is false
	 * If "true" count is more than 0 then value is true
	 * 
	 * Events:
	 * 	- Event.CHANGE - value is changed
	 * 
	 * @author Marek Brun
	 */
	public class MultiBoolean extends Base {

		private var dictID_True:Dictionary = new Dictionary()
		private var _value:Boolean;
		private var countTrue:uint;

		public function MultiBoolean() {
		}

		public function get value():Boolean {
			return _value;
		}

		public function setFalseToAll():void {
			dictID_True = new Dictionary();			countTrue = 0;
			checkChange();
		}

		public function setIsTrue(id:*, isTrue:Boolean):void {
			if(isTrue) {
				if(!dictID_True[id]) {
					dictID_True[id] = true;
					countTrue++;
					checkChange();
				}
			} else {
				if(dictID_True[id]) {
					delete dictID_True[id];
					countTrue--;
					checkChange();
				}
			}
		}

		public function getValueById(id:*):Boolean {
			if(dictID_True[id]) return true
			return false
		}


		public function getTrueValues():Array {
			var arr:Array/*of * */=[];
			for(var v:* in dictID_True){
				arr.push(v);
			}
			return arr;
		}

		
		private function checkChange():void {
			if(_value != Boolean(countTrue)) {
				_value = Boolean(countTrue);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}
