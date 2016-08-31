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
package pl.brun.lib.actions {
	import flash.events.Event;

	/**
	 * Action wait for X frames until finish. Frames-timeout in other words.
	 * Can be used for example when you go to frame and want to wait until
	 * playhead go to specifed frame (use 2 frames timeout in such situation). 
	 * 
	 * Start - only external
	 * Finish - only internal
	 * 
	 * @author Marek Brun
	 */
	public class FramesTimeoutAction extends Action {

		private var framesCount:uint = 2;
		private var curentFramesCount:uint;

		public function FramesTimeoutAction() {
		}

		public function setupFramesCount(frames:uint):void {
			framesCount = frames;
		}

		override protected function doRunning():void {
			curentFramesCount = framesCount;
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		override protected function canBeFinished():Boolean {
			return curentFramesCount == 0;
		}

		override protected function doIdle():void {
			root.removeEventListener(Event.ENTER_FRAME, onStage_EnterFrame);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			curentFramesCount--;
			if(canBeFinished()) {
				finish();
			}
		}
	}
}
