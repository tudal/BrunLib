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
package pl.brun.lib.display {
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.implementations.DisplayAction;
	import pl.brun.lib.display.actions.MCPlayToIniMidEnd;
	import pl.brun.lib.util.func.delayCall2;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Marek Brun
	 */
	public class ShowAnim2 extends DisplayAction {

		private var animMC:MovieClip;
		private var animIme:MCPlayToIniMidEnd;
		private var toShow:Array /*of Action*/= [];
		private var currentAction:DisplayAction;
		private var autoDispose:Boolean;

		public function ShowAnim2(animMC:MovieClip, autoDispose:Boolean) {
			super(new Sprite())
			this.autoDispose = autoDispose
			this.animMC = animMC
			animMC.gotoAndStop(1)
			
			animIme = new MCPlayToIniMidEnd(animMC)			animIme.addEventListener(ActionEvent.RUNNING_FINISH, onAnimIme_RunningFinish)
			addChildAction(animIme)
		}

		/**
		 * Embeeds paased display action in animated contener ans starts show animation.
		 * If there's some current showed action, then that action is closed first.
		 */
		public function show(action:DisplayAction):void {
			toShow.push(action)
			tryStartNext()
		}

		private function tryStartNext():void {
			if(currentAction) {
				if(currentAction.isInMidState()) {
					currentAction.finish()
				}
				return
			}
			if(toShow.length) {
				currentAction = DisplayAction(toShow.shift())
				addEventSubscription(currentAction, ActionEvent.RUNNING_START, onCurrentAction_RunningStart)
				addEventSubscription(currentAction, ActionEvent.RUNNING_MIDDLE_ENTER, onCurrentAction_RunningMiddleEnter)
				addEventSubscription(currentAction, ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish)
				if(currentAction.isRunning) {
					animIme.start()
					animMC.holder.addChild(currentAction.display)
				} else {
					currentAction.start()
				}			} else {
				finish()
			}
		}

		private function onCurrentAction_RunningStart(event:ActionEvent):void {
			animIme.start()
			animMC.holder.addChild(currentAction.display)
		}
		private function onCurrentAction_RunningMiddleEnter(event:ActionEvent):void {
			if(toShow.length) {
				currentAction.finish()
			}		}

		private function onCurrentAction_RunningFinish(event:ActionEvent):void {
			animIme.finish()
		}

		private function onAnimIme_RunningFinish(event:ActionEvent):void {
			delayCall2(this, finalize)
		}

		private function finalize():void {
			if(autoDispose) {
				currentAction.dispose()
			}else if(currentAction.display.parent && currentAction.display.parent == animMC.holder) {
				animMC.holder.removeChild(currentAction.display)
			}
			removeEventSubscription(currentAction, ActionEvent.RUNNING_START, onCurrentAction_RunningStart)
			removeEventSubscription(currentAction, ActionEvent.RUNNING_MIDDLE_ENTER, onCurrentAction_RunningMiddleEnter)
			removeEventSubscription(currentAction, ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish)
			currentAction = null
			tryStartNext()
		}

		override public function dispose():void {
			animIme.dispose()
			super.dispose()
		}
	}
}
