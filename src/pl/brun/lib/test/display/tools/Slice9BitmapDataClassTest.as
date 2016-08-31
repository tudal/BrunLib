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
package pl.brun.lib.test.display.tools {
	import pl.brun.lib.display.tools.Slice9BitmapData;
	import pl.brun.lib.test.TestBase;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	/**
	 * created: 2009-12-15
	 * @author Marek Brun
	 */
	public class Slice9BitmapDataClassTest extends TestBase {

		private var mc:Slice9BitmapDataClassTestMC;
		private var slice9:Slice9BitmapData;
		private var bitmapDisplay:Bitmap;

		public function Slice9BitmapDataClassTest() {
			mc = new Slice9BitmapDataClassTestMC();
			mc.removeChild(mc.scaledmc);
			addChild(mc);
			
			slice9 = Slice9BitmapData.createFromSlicedMC(mc.scaledmc);
			slice9.smoothing = true;
			
			bitmapDisplay = new Bitmap();
			bitmapDisplay.x = 100;			bitmapDisplay.y = 100;
			mc.addChild(bitmapDisplay);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove, false, 0, true);
			
			drawByMousePosition();
		}

		private function drawByMousePosition():void {
			if(bitmapDisplay.bitmapData) {
				bitmapDisplay.bitmapData.dispose();
			}
			bitmapDisplay.bitmapData = slice9.getScaled9BitmapData(bitmapDisplay.mouseX, bitmapDisplay.mouseY);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onStage_MouseMove(event:MouseEvent):void {
			drawByMousePosition();
		}
	}
}
