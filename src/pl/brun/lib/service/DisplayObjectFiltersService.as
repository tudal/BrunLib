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
package pl.brun.lib.service {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * @author Marek Brun
	 */
	public class DisplayObjectFiltersService {

		private static const servicedObjects:Dictionary = new Dictionary(true);
		private var display:DisplayObject;
		private var filtersByID:Dictionary;

		public function DisplayObjectFiltersService(access:Private, display:DisplayObject) {
			this.display = display;
			filtersByID = new Dictionary(true);
		}

		/**
		 * @param id - in the most cases it will be "this"
		 * @param filters - Array of BitmapFilter
		 */
		public function setFiltersFromID(id:*, filters:Array/*of BitmapFilter*/):void {
			filtersByID[id] = filters;
			updateFilters();
		}

		protected function updateFilters():void {
			var allFilters:Array = [];
			for(var i:* in filtersByID) {
				allFilters = allFilters.concat(filtersByID[i]);
			}
			display.filters = allFilters;
		}

		public static function forInstance(display:DisplayObject):DisplayObjectFiltersService {
			if(servicedObjects[display]) {
				return servicedObjects[display];
			}
			servicedObjects[display] = new DisplayObjectFiltersService(null, display);
			return servicedObjects[display];
		}
	}
}

internal class Private {
}