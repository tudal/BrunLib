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
package pl.brun.lib.display.actions {
	import pl.brun.lib.util.DisplayUtils;
	import pl.brun.lib.actions.Action;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class MCPlayToAction extends Action {

		private var _mc:MovieClip;
		private var targetFrame:uint;

		public function MCPlayToAction(mc:MovieClip, targetFrame:uint) {
			dbg.registerInDisplay(mc);
			_mc = mc;
			this.targetFrame = targetFrame;
		}

		override protected function doRunning():void {
			addEventSubscription(mc, Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		}

		override protected function doIdle():void {
			mc.stop();
			removeEventSubscription(mc, Event.ENTER_FRAME, onEnterFrame);
		}

		override protected function canBeFinished():Boolean {
			return mc.currentFrame == targetFrame;
		}

		override public function dispose():void {
			DisplayUtils.disposeDisplay(_mc)
			_mc = null
			super.dispose();
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		//------------------------------------------------------------------------------
		//		handlers
		//------------------------------------------------------------------------------
		private function onEnterFrame(event:Event):void {
			if(canBeFinished()) {
				finish();
			}else if(mc.currentFrame < targetFrame) {
				mc.play();
			}else if(mc.currentFrame > targetFrame) {
				mc.prevFrame();
				mc.stop();
			}
		}
	}
}
