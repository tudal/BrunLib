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
	import pl.brun.lib.display.tools.MCFrameEnterDispatcher;
	import pl.brun.lib.test.TestBase;

	/**
	 * @author Marek Brun
	 */
	public class MCFrameEnterEventDispatcherClassTest extends TestBase {

		private var mc:MCFrameEnterEventDispatcherTestMC;
		private var reciveController0:FramesReciverController;
		private var reciveController1:FramesReciverController;

		public function MCFrameEnterEventDispatcherClassTest() {
			mc = new MCFrameEnterEventDispatcherTestMC();
			holder.addChild(mc);
			
			dbg.log('forInstance working test:' + (MCFrameEnterDispatcher.forInstance(mc.anim) == MCFrameEnterDispatcher.forInstance(mc.anim) ? 'passed' : 'fail'));
			
			reciveController0 = new FramesReciverController(mc.recive0, mc.anim);
			reciveController0.id = 0;			reciveController1 = new FramesReciverController(mc.recive1, mc.anim);			reciveController1.id = 1;
		}
	}
}
