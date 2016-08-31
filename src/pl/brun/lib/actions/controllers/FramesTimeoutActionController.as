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
package pl.brun.lib.actions.controllers {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;

	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class FramesTimeoutActionController extends AbstractActionController {

		private var framesCount:uint;
		public var isStart:Boolean;
		public var isWaitToActionFinish:Boolean;

		public function FramesTimeoutActionController(action:Action, framesCount:uint, isStart:Boolean = true, isWaitToActionFinish:Boolean = false) {
			super(action);
			this.framesCount = framesCount;
			this.isStart = isStart;
			this.isWaitToActionFinish = isWaitToActionFinish;
		}

		override protected function doRunning():void {
			addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame);
		}

		override protected function canBeFinished():Boolean {
			if(!framesCount) {
				return true;
			}
			if(isWaitToActionFinish && isStart && !controlledAction.isRunning) {
				return true;
			}
			return false;
		}

		override protected function isDisposeAfterFinishWithNoRestart():Boolean {
			return true;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			framesCount--;
			if(!framesCount) {
				removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame);
				if(isStart) {
					controlledAction.start();
				} else {
					controlledAction.finish();
				}
				if(isWaitToActionFinish && isStart && controlledAction.isRunning) {
					addEventSubscription(controlledAction, ActionEvent.RUNNING_FINISH, onControlledAction_RunningFinish);
				} else {
					finish();
				}
			}
		}

		private function onControlledAction_RunningFinish(event:ActionEvent):void {
			finish();
		}
	}
}

