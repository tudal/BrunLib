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
package pl.brun.lib.test.display.button {
	import pl.brun.lib.display.button.ButtonEvent;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.display.button.views.AlphaWhenDisableButtonView;
	import pl.brun.lib.display.button.views.ContrastButtonView;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class ButtonsTest extends TestBase {

		private var mc:MCButtonClassTestMC;
		private var btn0:MCButton;
		private var btn1:MCButton;
		private var btn2:MCButton;

		public function ButtonsTest() {
			mc = new MCButtonClassTestMC();
			holder.addChild(mc);
			
			btn0 = MCButton.forInstance(mc.btn0);			btn1 = MCButton.forInstance(mc.btn1);			btn2 = MCButton.forInstance(mc.btn2);
			
			btn0.addView(new AlphaWhenDisableButtonView(mc.btn0));			btn0.addView(new ContrastButtonView(this));			btn1.addView(new AlphaWhenDisableButtonView(mc.btn1));			btn2.addView(new AlphaWhenDisableButtonView(mc.btn2));
			
			mc.btnFreeze0.addEventListener(MouseEvent.CLICK, onBtnFreeze0_Click);			mc.btnFreeze1.addEventListener(MouseEvent.CLICK, onBtnFreeze1_Click);			mc.btnFreeze2.addEventListener(MouseEvent.CLICK, onBtnFreeze2_Click);			
			mc.btnDisable0.addEventListener(MouseEvent.CLICK, onBtnDisable0_Click);			mc.btnDisable1.addEventListener(MouseEvent.CLICK, onBtnDisable1_Click);			mc.btnDisable2.addEventListener(MouseEvent.CLICK, onBtnDisable2_Click);
			
			btn0.addEventListener(ButtonEvent.OVER, onBtn0_Over);			btn0.addEventListener(ButtonEvent.MOVE_OVER, onBtn0_MoveOver);			btn0.addEventListener(ButtonEvent.PRESS, onBtn0_Press);			btn0.addEventListener(ButtonEvent.DRAG_MOVE, onBtn0_DragMove);			btn0.addEventListener(ButtonEvent.DRAG_OUT, onBtn0_DragOut);			btn0.addEventListener(ButtonEvent.DRAG_OVER, onBtn0_DragOver);			btn0.addEventListener(ButtonEvent.RELEASE, onBtn0_Release);			btn0.addEventListener(ButtonEvent.RELEASE_OVER, onBtn0_ReleaseOver);			btn0.addEventListener(ButtonEvent.RELEASE_OUTSIDE, onBtn0_ReleaseOutside);			btn0.addEventListener(ButtonEvent.OUT, onBtn0_Out);			btn0.addEventListener(ButtonEvent.DISABLE, onBtn0_Disable);			btn0.addEventListener(ButtonEvent.ENABLE, onBtn0_Enable);			btn0.addEventListener(ButtonEvent.FREEZE, onBtn0_Freeze);			btn0.addEventListener(ButtonEvent.UNFREEZE, onBtn0_Unfreeze);
			
			drawLabels();
		}

		private function drawLabels():void {
			var freeze:Array = 'freeze,unfreeze'.split(',');			var enable:Array = 'enable,disable'.split(',');
			mc.btnFreeze0.label = freeze[int(btn0.isFreeze)];			mc.btnFreeze1.label = freeze[int(btn1.isFreeze)];			mc.btnFreeze2.label = freeze[int(btn2.isFreeze)];			mc.btnDisable0.label = enable[int(btn0.isEnabled)];			mc.btnDisable1.label = enable[int(btn1.isEnabled)];			mc.btnDisable2.label = enable[int(btn2.isEnabled)];
			mc.btnDisable0.enabled = !btn0.isFreeze;			mc.btnDisable1.enabled = !btn1.isFreeze;			mc.btnDisable2.enabled = !btn2.isFreeze;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnFreeze0_Click(event:MouseEvent):void {
			btn0.isFreeze = !btn0.isFreeze;
			drawLabels();
		}

		private function onBtnFreeze1_Click(event:MouseEvent):void {
			btn1.isFreeze = !btn1.isFreeze;
			drawLabels();
		}

		private function onBtnFreeze2_Click(event:MouseEvent):void {
			btn2.isFreeze = !btn2.isFreeze;
			drawLabels();
		}

		private function onBtnDisable0_Click(event:MouseEvent):void {
			btn0.isEnabled = !btn0.isEnabled;
			drawLabels();
		}

		private function onBtnDisable1_Click(event:MouseEvent):void {
			btn1.isEnabled = !btn1.isEnabled;
			drawLabels();
		}

		private function onBtnDisable2_Click(event:MouseEvent):void {
			btn2.isEnabled = !btn2.isEnabled;
			drawLabels();
		}

		private function onBtn0_Over(event:ButtonEvent):void {
			dbg.log('onBtn0_Over()');
		}

		private function onBtn0_MoveOver(event:ButtonEvent):void {
			dbg.log('onBtn0_MoveOver()');
		}

		private function onBtn0_Press(event:ButtonEvent):void {
			dbg.log('onBtn0_Press()');
		}

		private function onBtn0_DragMove(event:ButtonEvent):void {
			dbg.log('onBtn0_DragMove()');
		}

		private function onBtn0_DragOut(event:ButtonEvent):void {
			dbg.log('onBtn0_DragOut()');
		}

		private function onBtn0_DragOver(event:ButtonEvent):void {
			dbg.log('onBtn0_DragOver()');
		}

		private function onBtn0_Release(event:ButtonEvent):void {
			dbg.log('onBtn0_Release()');
		}

		private function onBtn0_ReleaseOver(event:ButtonEvent):void {
			dbg.log('onBtn0_ReleaseOver()');
		}

		private function onBtn0_ReleaseOutside(event:ButtonEvent):void {
			dbg.log('onBtn0_ReleaseOutside()');
		}

		private function onBtn0_Out(event:ButtonEvent):void {
			dbg.log('onBtn0_Out()');
		}

		private function onBtn0_Disable(event:ButtonEvent):void {
			dbg.log('onBtn0_Disable()');
		}

		private function onBtn0_Enable(event:ButtonEvent):void {
			dbg.log('onBtn0_Enable()');
		}

		private function onBtn0_Freeze(event:ButtonEvent):void {
			dbg.log('onBtn0_Freeze()');
		}

		private function onBtn0_Unfreeze(event:ButtonEvent):void {
			dbg.log('onBtn0_Unfreeze()');
		}
	}
}
