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
package pl.brun.lib.models.easing {
	import pl.brun.lib.Base;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Events:
	 *  - Event.CHANGE
	 * 
	 * created: 2009-12-01
	 * @author Marek Brun
	 */
	public class EasingByID extends Base {

		private static var dictID_Instance:Dictionary = new Dictionary();
		private static var dictEasing_ID:Dictionary = new Dictionary();
		private var _easing:Easing;
		private var id:String;

		public function EasingByID(id:String) {
			this.id = id;
			easing = new SinEasing();
		}

		public function get easing():Easing {
			return _easing;
		}

		public function set easing(easing:Easing):void {
			if(_easing) {
				delete dictEasing_ID[easing];
			}
			_easing = easing;			dictEasing_ID[easing] = id;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public static function getIDManagerByEasing(easing:Easing):EasingByID {
			if(dictEasing_ID[easing]) {
				return forID(dictEasing_ID[easing]);
			}
			return null;
		}

		public static function forID(id:String):EasingByID {
			if(!dictID_Instance[id]) {
				dictID_Instance[id] = new EasingByID(id);
			}
			return dictID_Instance[id];
		}
	}
}
