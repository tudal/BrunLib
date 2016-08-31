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
	import pl.brun.lib.display.tools.MCNewFrameEnterDispatcher;
	import pl.brun.lib.display.tools.MCNewFrameEnterEvent;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class MCNewFrameEnterDispatcherClassTest extends TestBase {

		private var mc:MCNewFrameEnterDispatcherClassTestMC;

		public function MCNewFrameEnterDispatcherClassTest() {
			mc = new MCNewFrameEnterDispatcherClassTestMC();
			holder.addChild(mc);
			
			mc.btnPlay.addEventListener(MouseEvent.CLICK, onBtnPlay_Click);			mc.btnStop.addEventListener(MouseEvent.CLICK, onBtnStop_Click);
			
			MCNewFrameEnterDispatcher.forInstance(mc.anim).addEventListener(MCNewFrameEnterEvent.ENTER_NEW_FRAME, onMCAnim_EnterNewFrame);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnStop_Click(event:MouseEvent):void {
			mc.anim.stop();
		}

		private function onBtnPlay_Click(event:MouseEvent):void {
			mc.anim.play();
		}

		private function onMCAnim_EnterNewFrame(event:MCNewFrameEnterEvent):void {
			mc.anim2.gotoAndStop(event.mc.currentFrame);			mc.anim3.gotoAndStop(event.mc.currentFrame);
		}
	}
}
