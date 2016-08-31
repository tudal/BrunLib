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
package pl.brun.lib.test.actions {
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.ActionsQueue;
	import pl.brun.lib.actions.ActionsQueueEvent;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class ActionsQueueClassTest extends TestBase {

		private var mc:QueuedActionsClassTestMC;
		private var queue:ActionsQueue;
		private var mc_actionsMCsHolder:Sprite;
		private var countActions:uint;

		public function ActionsQueueClassTest() {
			mc = new QueuedActionsClassTestMC();
			holder.addChild(mc);
			
			mc.buttonAddAction.addEventListener(MouseEvent.CLICK, onButtonAddAction_Click);
			
			mc_actionsMCsHolder = new Sprite();
			mc_actionsMCsHolder.name = 'actionsMCsHolder';
			mc.addChild(mc_actionsMCsHolder);
			
			queue = new ActionsQueue();
			queue.addEventListener(ActionEvent.RUNNING_START, onQueue_RunningStart);			queue.addEventListener(ActionEvent.RUNNING_FINISH, onQueue_RunningFinish);
			queue.addEventListener(ActionsQueueEvent.QUEUED_ACTION_FINISH, onQueue_QueuedActionFinish);
			queue.addEventListener(ActionsQueueEvent.QUEUED_ACTION_START, onQueue_QueuedActionStart);			queue.addEventListener(ActionsQueueEvent.QUEUED_ACTION_FINISH, onQueue_QueuedActionFinish);
			queue.isAutoStart = true;
			
			createAndAddAction();			createAndAddAction();			createAndAddAction();			createAndAddAction();
		}

		private function drawQueueList():void {
			DisplayUtils.removeAllChildren(mc_actionsMCsHolder);
			if(queue.isRunning) {
				var actionsInQueue:Array /*of Action*/ = queue.getUnstartedActions();
				if(queue.getCurrentAction()) {
					actionsInQueue.unshift(queue.getCurrentAction());
				}
				
				var i:uint;
				var loop:RollWhellAndAnimAction;
				var currentY:Number = 0;
				for(i = 0;i < actionsInQueue.length;i++) {
					loop = actionsInQueue[i];
					mc_actionsMCsHolder.addChild(loop.mc_anim);
					loop.mc_anim.y = currentY;
					currentY += loop.mc_anim.height + 10;
				}
				dbg.log('queue.getUnstartedActions():' + dbg.link(queue.getUnstartedActions(), true));
			}
		}

		private function createAndAddAction():void {
			countActions++;
			var oneActionMC:OneActionAnimMC = new OneActionAnimMC();
			oneActionMC.gotoAndStop('ini');
			var action:RollWhellAndAnimAction = new RollWhellAndAnimAction(oneActionMC.controls, String(countActions), 'íni', 'mid', oneActionMC, 'mid', 'end');
			action.isSelfFinish = true;
			queue.addAction(action);
			drawQueueList();
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onButtonAddAction_Click(event:MouseEvent):void {
			createAndAddAction();
		}

		private function onQueue_RunningFinish(event:ActionEvent):void {
			dbg.log('onQueue_RunningFinish()');
		}

		private function onQueue_RunningStart(event:ActionEvent):void {
			dbg.log('onQueue_RunningStart()');
		}

		private function onQueue_QueuedActionStart(event:ActionsQueueEvent):void {
			dbg.log('onQueue_QueuedActionStart()');
			drawQueueList();
		}

		private function onQueue_QueuedActionFinish(event:ActionsQueueEvent):void {
			dbg.log('onQueue_QueuedActionFinish()');
			drawQueueList();
		}
	}
}
