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
	import flash.display.DisplayObject;

	/**
	 * @author Marek Brun
	 */
	public class OverFilterButtonView extends AbstractButtonView {

		private var mc:DisplayObject;
		private var filters:Array/*of BitmapFilter*/;
		private var filtersBeforePress:Array;

		public function OverFilterButtonView(mc:DisplayObject, filters:Array/*of BitmapFilter*/) {
			this.filters = filters;
			this.mc = mc;
		}

		override protected function doRollOver():void {
			filtersBeforePress = mc.filters.concat();
			mc.filters = filters;
		}

		override protected function doRollOut():void {
			mc.filters = filtersBeforePress;
		}
	}
}
