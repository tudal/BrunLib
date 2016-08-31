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
	import pl.brun.lib.util.ArrayUtils;

	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * Starts with first start of registered action.
	 * Finish with finish of last running action
	 * 
	 * @author Marek Brun
	 */
	public class MultiActions extends Action {

		public var isRandomStart:Boolean = false		public var randomStartMinTime:uint = 50		public var randomStartMaxTime:uint = 200
		private var observedActions:Dictionary = new Dictionary(true);		private var runningActions:Array /*of Action*/= [];
		private var toStart:Array/*of Action*/;
		private var startNextTimeoutID:uint;

		public function MultiActions(actions:Array/*of Action*/) {
			var i:uint;
			var action:Action;
			for(i = 0;i < actions.length;i++) {
				action = actions[i];
				addAction(action)
			}
		}

		override protected function prepareToFinish():void {
			var i:uint;
			var action:Action
			for(i = 0;i < runningActions.length;i++) {
				action = runningActions[i]
				action.finish()
			}
			
		}

		override protected function doRunning():void {
			dbg.log("doRunning("+dbg.linkArr(arguments, true)+')')
			var a:*
			if(isRandomStart) {
				toStart = []
				for(a in observedActions) {
					toStart.push(Action(a))
				}
				toStart = ArrayUtils.shuffle(toStart)
				startNext()
			} else {
				for(a in observedActions) {
					Action(a).start()
				}
			}
		}

		private function startNext():void {
			Action(toStart.pop()).start()
			if(toStart.length) {
				startNextTimeoutID = setTimeout(startNext, randomStartMinTime + Math.random() * (randomStartMaxTime - randomStartMinTime))
			}
		}

		override protected function canBeFinished():Boolean {
			return runningActions.length == 0;
		}

		public function addAction(action:Action):void {
			if(observedActions[action]) { 
				return; 
			}
			observedActions[action] = true;
			addEventSubscription(action, ActionEvent.RUNNING_START, onAction_RunningStart)			addEventSubscription(action, ActionEvent.RUNNING_FINISH, onAction_RunningFinish)
			if(action.isRunning) {
				runningActions.push(action)
				start();
			}
		}

		private function onAction_RunningStart(event:ActionEvent):void {
			runningActions.push(event.target)
			start();
		}

		private function onAction_RunningFinish(event:ActionEvent):void {
			ArrayUtils.remove(runningActions, event.target)
			if(!runningActions.length) {
				finish();
			}
		}
	}
}
