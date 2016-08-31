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
package pl.brun.lib.test.display.ui.threeParts {
	import pl.brun.lib.display.ui.threeParts.ThreePartsDisplay;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;

	/**
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public class ThreePartsDisplayClassTest extends TestBase {

		private var mc:ThreePartsDisplayClassTestMC;
		private var threeParts:ThreePartsDisplay;
		private var tap:ThreePartsDisplay;

		public function ThreePartsDisplayClassTest() {
			mc = new ThreePartsDisplayClassTestMC();
			holder.addChild(mc);
			
			tap = new ThreePartsDisplay(mc.tap);
			tap.isSmashable = false;
						threeParts = new ThreePartsDisplay(mc.threeParts, false);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove, false, 0, true);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onStage_MouseMove(event:MouseEvent):void {
			tap.size = mouseY - tap.container.y;			threeParts.size = mouseX - threeParts.container.x;
		}
	}
}
