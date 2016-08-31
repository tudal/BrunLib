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
package pl.brun.lib.test.display.ui {
	import fl.events.SliderEvent;

	import pl.brun.lib.display.ui.tooltip.Tooltip;
	import pl.brun.lib.test.TestBase;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * created:2009-11-17 
	 * @author Marek Brun
	 */
	public class MCToolipClassTest extends TestBase {

		private var mc:MCToolipClassTestMC;
		private var tooltip:Tooltip;

		public function MCToolipClassTest() {
			mc = new MCToolipClassTestMC();
			holder.addChild(mc);
			
			tooltip = new Tooltip(mc.tooltip1, mc);
			
			mc.alignSlider.minimum = 0;			mc.alignSlider.maximum = 4;
			mc.alignSlider.liveDragging = true;			mc.alignSlider.snapInterval = 0.1;
			
			mc.marginSlider.minimum = 0;
			mc.marginSlider.maximum = 20;
			mc.marginSlider.liveDragging = true;
			mc.marginSlider.snapInterval = 0.1;
			
			var btnOverCount:uint = 0;
			
			while(mc['btnOver' + btnOverCount]) {
				mc['btnOver' + btnOverCount].addEventListener(MouseEvent.MOUSE_OVER, onBtnOver_Over);				mc['btnOver' + btnOverCount].addEventListener(MouseEvent.MOUSE_OUT, onBtnOver_Out);
				btnOverCount++;
			}
			
			mc.alignSlider.addEventListener(SliderEvent.THUMB_PRESS, onAlignSlider_ThumbPress);			mc.alignSlider.addEventListener(SliderEvent.THUMB_RELEASE, onAlignSlider_ThumbRelease);			mc.alignSlider.addEventListener(Event.CHANGE, onSlider_Change);			mc.marginSlider.addEventListener(Event.CHANGE, onSlider_Change);			
			mc.checkAlign.addEventListener(Event.CHANGE, onCheckAlign_Change);
			
			tooltip.setText(getRandomText(), false);
			
			draw();
		}

		private function draw():void {
			mc.alignLabel.text = 'align:' + String(mc.alignSlider.value);			mc.marginLabel.text = 'margin:' + String(mc.marginSlider.value);
			mc.alignSlider.enabled = !mc.checkAlign.selected;
		}

		private function getRandomText():String {
			var baseText:String = 'Some text, some text, some text, some text';
			var linesCount:uint = 1 + int(Math.random() * 6);
			var lines:Array /*of String*/ = [];
			while(linesCount) {
				linesCount--;
				lines.push(baseText.substr(0, int(baseText.length * Math.random())));
			}
			return lines.join('\n');
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnOver_Over(event:MouseEvent):void {
			tooltip.margin = mc.marginSlider.value;
			tooltip.setAlign(mc.alignSlider.value);
			tooltip.setText(getRandomText(), true, mc.checkAlign.selected);
		}

		private function onBtnOver_Out(event:MouseEvent):void {
			tooltip.setIsVisible(false);
		}

		private function onSlider_Change(event:Event):void {
			tooltip.setAlign(mc.alignSlider.value);
			draw();
		}

		private function onAlignSlider_ThumbPress(event:SliderEvent):void {
			tooltip.setIsVisible(true);
		}

		private function onAlignSlider_ThumbRelease(event:SliderEvent):void {
			tooltip.setIsVisible(false);
		}

		private function onCheckAlign_Change(event:Event):void {
			draw();
		}
	}
}
