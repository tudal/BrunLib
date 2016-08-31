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
package pl.brun.lib.display.button.views {
	import pl.brun.lib.service.DisplayObjectFiltersService;

	import flash.display.DisplayObject;

	/**
	 * @author Marek Brun
	 */
	public class FilterOverButtonView extends AbstractButtonView {

		private var display:DisplayObject;
		private var filters:Array;
		private var fs:DisplayObjectFiltersService;

		public function FilterOverButtonView(display:DisplayObject, filters:Array) {
			this.filters = filters;
			this.display = display;
			fs = DisplayObjectFiltersService.forInstance(display)
		}

		override protected function doRollOver():void {
			fs.setFiltersFromID(this, filters)
		}

		override protected function doRollOut():void {
			fs.setFiltersFromID(this, [])
		}
	}
}
