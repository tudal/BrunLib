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
package pl.brun.lib.actions.tools {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;

	import flash.utils.Dictionary;

	/**
	 * Running - some observed action is running
	 * Idle - no observed action is running
	 * 
	 * Start - internal
	 * Finish - internal
	 * 
	 * 
	 * Class store observed actions in weak references.
	 * 
	 * @author Marek Brun
	 */
	public class AnyActionIsRunning extends Action {

		private var observedActions:Dictionary = new Dictionary(true);
		private var countRunningActions:uint;

		public function AnyActionIsRunning() {
			countRunningActions = 0;
		}

		override protected function canBeStarted():Boolean {
			return countRunningActions > 0;
		}

		override protected function canBeFinished():Boolean {
			return countRunningActions == 0;
		}

		public function addActionToObserve(action:Action):void {
			if(observedActions[action]) { 
				return; 
			}
			observedActions[action] = true;
			addEventSubscription(action, ActionEvent.RUNNING_START, onAction_RunningStart);			addEventSubscription(action, ActionEvent.RUNNING_FINISH, onAction_RunningFinish);
			if(action.isRunning) {
				countRunningActions++;
				start();
			}
		}

		public function addActionsToObserve(actions:Array/*of Action*/):void {
			var i:uint;
			for(i = 0;i < actions.length;i++) {
				addActionToObserve(actions[i])
			}
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onAction_RunningStart(event:ActionEvent):void {
			countRunningActions++;
			start();
		}

		private function onAction_RunningFinish(event:ActionEvent):void {
			countRunningActions--;
			finish();
		}
	}
}
