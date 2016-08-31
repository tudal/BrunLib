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
	import pl.brun.lib.display.tools.MCPauser;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class MCPauserClassTest extends TestBase {

		private var mc:MCPauserClassTestMC;
		private var mcAnimPauser:MCPauser;

		public function MCPauserClassTest() {
			mc = new MCPauserClassTestMC();
			holder.addChild(mc);
			
			mcAnimPauser = MCPauser.forInstance(mc.anim);
			
			dbg.log('forInstance working test:' + (mcAnimPauser == MCPauser.forInstance(mc.anim) ? 'passed' : 'fail'));
			
			mc.btnPauseRestore.addEventListener(MouseEvent.CLICK, onBtnPauseRestore_Click);
			
			drawBtnPauseRestoreLabel();
		}

		private function drawBtnPauseRestoreLabel():void {
			mc.btnPauseRestore.label = mcAnimPauser.isPaused ? 'restore' : 'pause';
		}

		//----------------------------------------------------------------------
		//		handlers
		//----------------------------------------------------------------------
		private function onBtnPauseRestore_Click(event:MouseEvent):void {
			if(mcAnimPauser.isPaused) {
				mcAnimPauser.resume();
			} else {				mcAnimPauser.pause();
			}
			drawBtnPauseRestoreLabel();
		}
	}
}
