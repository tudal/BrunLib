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
	import pl.brun.lib.util.ArrayUtils;

	import flash.events.Event;

	[Event(name="queuedActionFinish", type="pl.brun.lib.actions.ActionsQueueEvent")]

	[Event(name="queuedActionStart", type="pl.brun.lib.actions.ActionsQueueEvent")]

	/**
	 * Running - any queued action is currently running
	 * Idle - no action in queue (if isAutoStart==true), or queue is not started
	 * 
	 * Start - internal( isAutoStart==true) and external
	 * Finish - internal
	 * 
	 * 
	 * Events:
	 *  - ActionsQueueEvent.QUEUED_ACTION_START	 *  - ActionsQueueEvent.QUEUED_ACTION_FINISH
	 * 
	 * @author Marek Brun
	 */
	public class ActionsQueue extends Action {

		/**
		 * when true - at start queued action will be remembered and then restored on finish
		 */
		public var isRestoreAfterFinish:Boolean;
		/**
		 * when true - queue will be started with first action added
		 */
		public var isAutoStart:Boolean;
		/**
		 * when true - adding action that is already in queued actions list to queue is ignored
		 */		public var isUniqueQueuedActionsList:Boolean;
		/**
		 * when true - finished actions are added to "finishedActions" array
		 */
		public var isStoreFinishedActions:Boolean;
		/**
		 * when true - starting of unstarted actions will be blocked until it's
		 * time to start form queue
		 */
		public var isBlockingUnstartedAction:Boolean = true;
		public var name:String;
		private var actionsToStart:Array /*of Action*/ = [];
		private var currentAction:Action;
		private var finishedActions:Array /*of Action*/;
		private var actionsAtStart:Array /*of Action*/;
		private var currentStartingAction:Action;

		public function ActionsQueue() {
		}

		/**
		 * Adds action to queue.
		 * If there's already that action adding is ignored (unique list).
		 */
		public function addAction(action:Action/*of Action*/):void {
			if(ArrayUtils.got(actionsToStart, action)) { 
				return; 
			}
			if(isBlockingUnstartedAction) {
				action.isStartBlocked = true;
			}
			actionsToStart.push(action);
			if(isAutoStart) { 
				start();
			}
		}

		/**
		 * Mass actions adding.
		 */
		public function addActions(actions:Array/*of Action*/):void {
			var i:uint;
			var loop:Action;
			for(i = 0;i < actions.length;i++) {
				loop = actions[i];
				addAction(loop);
			}
		}

		/**
		 * @return true when there's unstarted action in queue list
		 */
		public function gotAction(action:Action):Boolean {
			return ArrayUtils.got(actionsToStart, action);
		}

		/**
		 * @return current running action
		 */
		public function getCurrentAction():Action {
			return currentAction;
		}

		override protected function canBeStarted():Boolean {
			if(!actionsToStart.length) {
				return false; 
			}
			return true;
		}

		override protected function doMiddleEnter():void {
			if(isRestoreAfterFinish) { 
				actionsAtStart = actionsToStart.concat();
			}
			finishedActions = [];
			tryStartNextAction();
		}

		override protected function canBeFinished():Boolean {
			if(currentAction && currentAction.isRunning) {
				currentAction.finish();
				return false;
			} else {
				if(isRestoreAfterFinish) {
					actionsToStart = actionsAtStart;
					actionsAtStart = null;
				}
				return true;
			}
			return false;
		}

		override protected function doIdle():void {
			if(isRestoreAfterFinish) {
				actionsToStart = actionsAtStart;
				actionsAtStart = null;
			}
		}

		private function tryStartNextAction():void {
			while(isRunningFlag && actionsToStart.length && Action(actionsToStart[0]).isDisposed){
				actionsToStart.shift()
			}
			if(actionsToStart.length && isRunningFlag) {
				currentAction = Action(actionsToStart.shift());
				addEventSubscription(currentAction, ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish);
				currentStartingAction = currentAction;
				dispatchEvent(new ActionsQueueEvent(ActionsQueueEvent.QUEUED_ACTION_START, currentAction));
				currentAction.isStartBlocked = false;
				currentAction.start();
				currentStartingAction = null;
			} else {
				finish();
			}
		}

		/**
		 * @return new array of Action
		 */
		public function getFinishedActions():Array /*of Action*/ {
			return finishedActions.concat();
		}

		/**
		 * @return new array of Action
		 */
		public function getUnstartedActions():Array /*of Action*/ {
			return actionsToStart.concat();
		}
		
		protected function onCurrentAction_RunningFinish(event:Event):void {
			removeEventSubscription(currentAction, ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish);
			dispatchEvent(new ActionsQueueEvent(ActionsQueueEvent.QUEUED_ACTION_FINISH, currentAction));
			if(isRunningFlag) {
				if(isStoreFinishedActions){
					finishedActions.push(currentAction);
				}
				currentAction = null;
				tryStartNextAction();
			} else {
				currentAction = null;
				finish();
			}
		}
	}
}
