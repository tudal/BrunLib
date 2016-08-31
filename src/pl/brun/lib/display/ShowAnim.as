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
	import pl.brun.lib.util.DisplayUtils;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.implementations.DisplayAction;
	import pl.brun.lib.display.actions.MCPlayToIniMidEnd;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * @author Marek Brun
	 */
	public class ShowAnim extends DisplayAction {

		private var animMC:MovieClip;
		private var animIme:MCPlayToIniMidEnd;
		private var queuedAction:Array /*of DisplayAction*/= [];
		private var _currentAction:DisplayAction;

		public function ShowAnim(animMC:MovieClip) {
			super(new Sprite())
			this.animMC = animMC
			animMC.gotoAndStop(1)
			
			animIme = new MCPlayToIniMidEnd(animMC)			animIme.addEventListener(ActionEvent.RUNNING_MIDDLE_ENTER, onAnimIme_RunningMiddleEnter)			animIme.addEventListener(ActionEvent.RUNNING_FINISH, onAnimIme_RunningFinish)
			
			addChildAction(animIme)
		}

		private function tryStartNextPopup():void {
			if(!_currentAction && queuedAction.length) {
				_currentAction = queuedAction.shift()
				if(_currentAction.isDisposed) {
					tryStartNextPopup()
					return
				}
				animMC.holder.addChild(_currentAction.display)
				_currentAction.container.mouseChildren = false
				_currentAction.addEventListener(ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish)
				animIme.start()
			}else if(_currentAction && _currentAction.isRunning) {
				if(_currentAction.isInMidState()) {
					_currentAction.finish()
				}
				_currentAction.isRunningFlag = false
			}
		}

		/**
		 * Embeeds paased display action in animated contener ans starts show animation.
		 * If there's some current showed action, then that action is closed first.
		 */
		public function show(action:DisplayAction):void {
			queuedAction.push(action)			tryStartNextPopup()
		}

		private function onCurrentAction_RunningFinish(event:ActionEvent):void {
			if(!isDisposed) {				_currentAction.removeEventListener(ActionEvent.RUNNING_FINISH, onCurrentAction_RunningFinish)
				finish()
			}
		}

		private function onAnimIme_RunningMiddleEnter(event:ActionEvent):void {
			_currentAction.container.mouseChildren = true
			_currentAction.start()
		}

		private function onAnimIme_RunningFinish(event:ActionEvent):void {
			if(_currentAction) {
				DisplayUtils.removeChild(_currentAction.display)
				_currentAction.finish()
				_currentAction.parent = null
				_currentAction = null
			}
			FrameDelayCall.addCall2(this, tryStartNextPopup)
		}

		public function get currentPopup():DisplayAction {
			return _currentAction;
		}

		override public function dispose():void {
			animIme.dispose()
			queuedAction = []
			_currentAction = null
			super.dispose();
		}
	}
}
