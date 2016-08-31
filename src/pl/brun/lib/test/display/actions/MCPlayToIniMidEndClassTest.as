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
package pl.brun.lib.test.display.actions {
	import pl.brun.lib.display.actions.MCPlayToIniMidEnd;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.test.actions.ActionViewDisplay;

	/**
	 * @author Marek Brun
	 */
	public class MCPlayToIniMidEndClassTest extends TestBase {

		private var mc:MCPlayToIniMidEndClassTestMC;
		private var imeAnimAction:MCPlayToIniMidEnd;
		private var actionView:ActionViewDisplay;

		public function MCPlayToIniMidEndClassTest() {
			mc = new MCPlayToIniMidEndClassTestMC();
			holder.addChild(mc);
			
			imeAnimAction = new MCPlayToIniMidEnd(mc.imeAnim);
			
			actionView = new ActionViewDisplay(mc.actionView, imeAnimAction);
		}
	}
}
