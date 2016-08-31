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
package pl.brun.lib.actions.implementations {
	import pl.brun.lib.actions.Action;

	import flash.events.Event;

	/**
	 * created:2009-11-24
	 * @author Marek Brun
	 */
	public class EnterFrameAction extends Action {

		public function EnterFrameAction() {
		}

		/*abstract*/
		protected function doEnterFrame():void {
		}

		override protected function doRunning():void {
			addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame);
		}

		override protected function doIdle():void {
			removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			doEnterFrame();
		}
	}
}
