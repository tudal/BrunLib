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
package pl.brun.lib.test.display.ui.scroller {
	import pl.brun.lib.display.ui.scroller.Scroller;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.test.TestBase;

	/**
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public class ScrollerClassTest extends TestBase {

		private var mc:ScrollerClassTestMC;
		private var scroller1:Scroller;
		private var scroller2:Scroller;

		public function ScrollerClassTest() {
			mc = new ScrollerClassTestMC();
			holder.addChild(mc);
			
			scroller1 = new Scroller(mc.scroller1);
			scroller1.addEventListener(PositionEvent.POSITION_REQUEST, onScroller1_PositionRequest);			scroller2 = new Scroller(mc.scroller2);			scroller2.addEventListener(PositionEvent.POSITION_REQUEST, onScroller2_PositionRequest);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onScroller1_PositionRequest(event:PositionEvent):void {
			dbg.log('scroller1 event.position:' + dbg.link(event.position));
			scroller1.setScroll(event.position, 0.2, 1);
		}

		private function onScroller2_PositionRequest(event:PositionEvent):void {
			dbg.log('scroller2 event.position:' + dbg.link(event.position));
			scroller2.setScroll(event.position, 0.2, 1);
		}
	}
}
