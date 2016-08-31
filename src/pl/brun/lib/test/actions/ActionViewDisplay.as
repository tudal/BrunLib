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
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;

	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class ActionViewDisplay extends Base {

		private var _mc:ActionViewMC;
		private var action:Action;

		public function ActionViewDisplay(mc:ActionViewMC, action:Action) {
			//dbg.registerInDisplay(mc);
			this._mc = mc;
			this.action = action;
			
			mc.btnFinish.buttonMode = true;
			mc.btnStart.buttonMode = true;
			addEventSubscription(mc.btnFinish, MouseEvent.CLICK, onBtnFinish_Click);			addEventSubscription(mc.btnStart, MouseEvent.CLICK, onBtnStart_Click);
			
			addEventSubscription(action, ActionEvent.RUNNING_FLAG_CHANGED, onAction_RunningFlagChanged);
			addEventSubscription(action, ActionEvent.RUNNING_START, onAction_RunningStart);			addEventSubscription(action, ActionEvent.RUNNING_FINISH, onAction_RunningFinish);
			
			draw();
		}

		private function draw():void {
			mc.flag.gotoAndStop(action.isRunningFlag ? 1 : 2);			if(action.isRunning) {
				mc.circle.play();
			} else {
				mc.circle.gotoAndStop(mc.circle.totalFrames);
			}
		}

		public function get mc():ActionViewMC { 
			return _mc; 
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnStart_Click(event:MouseEvent):void {
			action.start();
		}

		private function onBtnFinish_Click(event:MouseEvent):void {
			action.finish();
		}

		private function onAction_RunningFlagChanged(event:ActionEvent):void {
			draw();
		}

		private function onAction_RunningFinish(event:ActionEvent):void {
			dbg.log('onAction_RunningFinish()');
			draw();
		}

		private function onAction_RunningStart(event:ActionEvent):void {
			draw();
		}
	}
}
