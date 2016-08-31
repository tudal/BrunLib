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
package pl.brun.lib.display.button.views {
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * Over - plays to the end of timeline
	 * Out - plays backward (using prevFrame()) to the 1st frame
	 * 
	 * @author Marek Brun
	 */
	public class PlayToEndAndBackButtonView extends AbstractButtonView {

		private var _mc:MovieClip;

		public function PlayToEndAndBackButtonView(mc:MovieClip) {
			this._mc = mc;
			mc.gotoAndStop(1);
		}

		public function get mc():MovieClip { 
			return _mc;
		}

		override protected function doRollOver():void {
			mc.addEventListener(Event.ENTER_FRAME, onMC_EnterFrame);
		}

		override protected function doRollOut():void {
			mc.addEventListener(Event.ENTER_FRAME, onMC_EnterFrame);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onMC_EnterFrame(event:Event):void {
			if(model.isOver) {
				if(mc.currentFrame == mc.totalFrames) {
					mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame);
					mc.stop();
				} else {
					mc.play();
				}
			} else {
				if(mc.currentFrame == 1) {
					mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame);
					mc.stop();
				} else {
					mc.prevFrame();
				}
			}
		}
	}
}
