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
package pl.brun.lib.display.displayObjects {
	import pl.brun.lib.util.MathUtils;

	import flash.errors.IllegalOperationError;
	import flash.geom.Point;

	/**
	 * Automatically align bitmap. 
	 * 
	 * created:2009-10-31 
	 * @author Marek Brun
	 */
	public class AlignedBitmapView extends BitmapView {

		private var maxWidth:Number;
		private var maxHeight:Number;		public var xAlign:int;
		public var yAlign:int;
		public var centerPoint:Point;
		private var rescaleIfSmaller:Boolean;

		/**
		 * @param xAlign - 
		 * 			-1 - LEFT
		 * 			0 - CENTER
		 * 			1 - RIGHT
		 * @param yAlign - 
		 * 			-1 - TOP
		 * 			0 - CENTER
		 * 			1 - BOTTOM
		 */
		public function AlignedBitmapView(maxWidth:Number, maxHeight:Number, xAlign:int, yAlign:int, centerPoint:Point, rescaleIfSmaller:Boolean = true) {
			this.rescaleIfSmaller = rescaleIfSmaller
			this.maxWidth = maxWidth
			this.maxHeight = maxHeight
			this.xAlign = xAlign			this.yAlign = yAlign
			this.centerPoint = centerPoint
		}

		override protected function doAfterNewBitmap():void {
			var newScale:Number = MathUtils.getRescaleToRect(maxWidth, maxHeight, bitmapData.width, bitmapData.height);
			if(!(newScale>1 && !rescaleIfSmaller)){
				scaleX = newScale;
				scaleY = newScale;
			}
			switch(xAlign) {
				case -1:
					x = centerPoint.x;
					break;
				case 0:
					x = centerPoint.x - width / 2;
					break;
				case 1:
					x = centerPoint.x - width;
					break;
				default:
					throw new IllegalOperationError("Unsupported xAlign value (" + xAlign + "). Supported values are -1, 0 and 1.");
			}
			switch(yAlign) {
				case -1:
					y = centerPoint.y;
					break;
				case 0:
					y = centerPoint.y - height / 2;
					break;
				case 1:
					y = centerPoint.y - height;
					break;
				default:
					throw new IllegalOperationError("Unsupported yAlign value (" + yAlign + "). Supported values are -1, 0 and 1.");
			}
		}
	}
}
