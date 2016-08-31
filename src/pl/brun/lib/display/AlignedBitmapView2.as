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
package pl.brun.lib.display {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Point;
	import pl.brun.lib.display.displayObjects.BitmapView;
	import pl.brun.lib.models.IBitmapProvider;
	import pl.brun.lib.util.MathUtils;


	/**
	 * Automatically align bitmap. 
	 * 
	 * created:2009-10-31 
	 * @author Marek Brun
	 */
	public class AlignedBitmapView2 extends DisplayBase {
		private var maxWidth:Number;
		private var maxHeight:Number;
		public var xAlign:int;
		public var yAlign:int;
		public var centerPoint:Point;
		public var rescale:Boolean=true;
		public var rescaleIfSmaller:Boolean;
		private var bmp:BitmapView;

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
		public function AlignedBitmapView2(maxWidth:Number, maxHeight:Number, xAlign:int, yAlign:int, smoothing:Boolean = true) {
			this.maxWidth = maxWidth
			this.maxHeight = maxHeight
			this.xAlign = xAlign
			this.yAlign = yAlign

			bmp = new BitmapView()
			bmp.smoothing = smoothing
			container.addChild(bmp)
			bmp.addEventListener(Event.CHANGE, onBMP_Change)
		}

		public function setModel(model:IBitmapProvider):void {
			bmp.setModel(model)
		}

		private function onBMP_Change(event:Event):void {
			var newScale:Number = MathUtils.getRescaleToRect(maxWidth, maxHeight, bmp.bitmapData.width, bmp.bitmapData.height);
			if (!rescale) {
				bmp.scaleX = 1
				bmp.scaleY = 1
			} else if (rescaleIfSmaller) {
				bmp.scaleX = newScale
				bmp.scaleY = newScale
			} else if (newScale > 1) {
				bmp.scaleX = 1
				bmp.scaleY = 1
			} else {
				bmp.scaleX = newScale
				bmp.scaleY = newScale
			}
			switch(xAlign) {
				case -1:
					bmp.x = 0
					break;
				case 0:
					bmp.x = maxWidth / 2 - bmp.width / 2
					break;
				case 1:
					bmp.x = maxWidth - bmp.width
					break;
				default:
					throw new IllegalOperationError("Unsupported xAlign value (" + xAlign + "). Supported values are -1, 0 and 1.");
			}
			switch(yAlign) {
				case -1:
					bmp.y = 0
					break;
				case 0:
					bmp.y = maxHeight / 2 - bmp.height / 2
					break;
				case 1:
					bmp.y = maxHeight - bmp.height
				default:
					throw new IllegalOperationError("Unsupported yAlign value (" + yAlign + "). Supported values are -1, 0 and 1.");
			}
		}
	}
}
