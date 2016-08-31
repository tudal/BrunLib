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
package pl.brun.lib.test.display.libraryItems {
	import pl.brun.lib.display.libraryItems.MCDetectEvent;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;

	/**
	 * created:2009-11-16 
	 * @author Marek Brun
	 */
	public class MCDetectableClassTest extends TestBase {

		private var mc:MCDetectableClassTestMC;

		public function MCDetectableClassTest() {
			mc = new MCDetectableClassTestMC();
			holder.addChild(mc);
			
			mc.addEventListener(MCDetectEvent.CREATED, onMC_Created);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onMC_Created(event:MCDetectEvent):void {
			dbg.log('created:' + DisplayUtils.getPatch(event.mc).join('.') + ' at ' + MovieClip(event.mc.parent).currentFrame + ' frame');
		}
	}
}
