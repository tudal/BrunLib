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

	import com.gskinner.geom.ColorMatrix;

	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	/**
	 * created: 2009-12-06
	 * @author Marek Brun
	 */
	public class ContrastButtonView extends AbstractButtonView {

		public var overContrast:Number;
		public var downContrast:Number;
		private var display:DisplayObject;

		/**
		 * @param overContrast from -100 to 100		 * @param downContrast from -100 to 100
		 */
		public function ContrastButtonView(display:DisplayObject, overContrast:Number = 10, downContrast:Number = 15) {
			this.display = display;
			this.downContrast = downContrast;
			this.overContrast = overContrast;
		}

		private function setContrast(contrast:int):void {
			var colorMatrix:ColorMatrix = new ColorMatrix((new ColorMatrixFilter()).matrix);
			if(display.filters.length){
				DisplayObjectFiltersService.forInstance(display).setFiltersFromID(display, display.filters)
			}
			display.filters=[new ColorMatrixFilter(colorMatrix)]
			DisplayObjectFiltersService.forInstance(display).setFiltersFromID(this, [new ColorMatrixFilter(colorMatrix)]);
		}

		override protected function doRollOver():void {
			setContrast(overContrast);
		}

		override protected function doPress():void {
			setContrast(downContrast);
		}

		override protected function doRelease():void {
			setContrast(overContrast);
		}

		override protected function doRollOut():void {
			DisplayObjectFiltersService.forInstance(display).setFiltersFromID(this, []);
		}
	}
}
