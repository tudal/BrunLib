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
	import pl.brun.lib.display.tools.MCRasterizer;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class MCRasterizerClassTest extends TestBase {

		private var mc:MCRasterizerClassTestMC;
		private var isBitmapSmoothing:Boolean = true;

		public function MCRasterizerClassTest() {
			mc = new MCRasterizerClassTestMC();
			holder.addChild(mc);
			stage.frameRate = 120;
			
			mc.btnStartRasterizing.addEventListener(MouseEvent.CLICK, onBtnStartRasterizing_Click);
			mc.btnSwitchSmoothing.addEventListener(MouseEvent.CLICK, onBtnSwitchSmoothing_Click);			
			mc.btnTest1.addEventListener(MouseEvent.CLICK, onBtnTest1_Click);			mc.btnTest2.addEventListener(MouseEvent.CLICK, onBtnTest2_Click);			mc.btnTest3.addEventListener(MouseEvent.CLICK, onBtnTest3_Click);
			
			//so there will be error if there is rastrtization request on clip
			//without linked class (in flash library)
			MCRasterizer.onlyMCWithClassName = true;
			
			setTest(1);
		}

		private function setTest(testNum:uint):void {
			mc.clipsToRasterize.gotoAndStop(testNum);
			mc.btnStartRasterizing.enabled = true;
			mc.btnSwitchSmoothing.enabled = false;
			mc.btnTest1.enabled = testNum != 1;			mc.btnTest2.enabled = testNum != 2;			mc.btnTest3.enabled = testNum != 3;
			drawButtonsLabel();
		}

		private function switchBitmapSmoothing():void {
			isBitmapSmoothing = !isBitmapSmoothing;
			startRasterizing();
			drawButtonsLabel();
		}

		private function drawButtonsLabel():void {
			mc.btnSwitchSmoothing.label = "isBitmapSmoothing=" + isBitmapSmoothing;
		}

		private function startRasterizing():void {
			mc.btnStartRasterizing.enabled = false;
			mc.btnSwitchSmoothing.enabled = true;
			var clips:Array /*of Action*/ = DisplayUtils.getChildren(mc.clipsToRasterize);
			var i:uint;
			var loop:MovieClip;
			for(i = 0;i < clips.length;i++) {
				if(clips[i] is MovieClip) {
					loop = clips[i];
					MCRasterizer.rasterize(loop).isBitmapSmoothing = isBitmapSmoothing;
				}
			}
		}

		//------------------------------------------------------------------------------
		//		handlers
		//------------------------------------------------------------------------------
		private function onBtnStartRasterizing_Click(event:MouseEvent):void {
			startRasterizing();
		}

		private function onBtnSwitchSmoothing_Click(event:MouseEvent):void {
			switchBitmapSmoothing();
		}

		private function onBtnTest1_Click(event:MouseEvent):void {
			setTest(1);
		}

		private function onBtnTest2_Click(event:MouseEvent):void {
			setTest(2);
		}

		private function onBtnTest3_Click(event:MouseEvent):void {
			setTest(3);
		}
	}
}
