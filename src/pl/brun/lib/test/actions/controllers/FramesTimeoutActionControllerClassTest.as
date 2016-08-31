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
package pl.brun.lib.test.actions.controllers {
	import fl.controls.NumericStepper;

	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionsQueue;
	import pl.brun.lib.actions.controllers.FramesTimeoutActionController;
	import pl.brun.lib.display.actions.MCPlayToEndAndBackAction;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.test.actions.ActionViewDisplay;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class FramesTimeoutActionControllerClassTest extends TestBase {

		private var mc:FramesTimeoutActionControllerClassTestMC;
		private var queue:ActionsQueue;
		private var animActions:Array /*of MCPlayToEndAndBackAction*/;
		private var controller:ActionViewDisplay;
		private var isReverse:Boolean;
		private var isStartTargetState:Boolean = true;

		public function FramesTimeoutActionControllerClassTest() {
			mc = new FramesTimeoutActionControllerClassTestMC();
			holder.addChild(mc);
			
			queue = new ActionsQueue();
			
			controller = new ActionViewDisplay(mc.actionView, queue);
			
			var animMCS:Array /*of MovieClip*/= [mc.anim0, mc.anim1, mc.anim2, mc.anim3, mc.anim4, mc.anim5];
			
			animActions = [];
			
			var i:uint;
			var loop:MovieClip;
			var animAction:MCPlayToEndAndBackAction;
			for(i = 0;i < animMCS.length;i++) {
				loop = animMCS[i];
				animAction = new MCPlayToEndAndBackAction(loop);
				animActions.push(animAction);
			}
			
			mc.btnIsReverse.addEventListener(MouseEvent.CLICK, onBtnIsReverse_Click);
			mc.btnIsStartTargetState.addEventListener(MouseEvent.CLICK, onBtnIsStartTargetState_Click);			mc.btnStartDetonator.addEventListener(MouseEvent.CLICK, onBtnStartDetonator_Click);
			
			drawButtonsLabels();
		}

		private function drawButtonsLabels():void {
			mc.btnIsReverse.label = 'isReverse = ' + isReverse;			mc.btnIsStartTargetState.label = 'isStartTargetState = ' + isStartTargetState;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnIsReverse_Click(event:MouseEvent):void {
			isReverse = !isReverse;
			drawButtonsLabels();
		}

		private function onBtnIsStartTargetState_Click(event:MouseEvent):void {
			isStartTargetState = !isStartTargetState;
			drawButtonsLabels();
		}

		private function onBtnStartDetonator_Click(event:MouseEvent):void {
			var i:uint;
			var loop:Action;
			var queueActions:Array /*of Action*/= [];
			for(i = 0;i < animActions.length;i++) {
				loop = animActions[i];
				queueActions.push(new FramesTimeoutActionController(loop, NumericStepper(mc.getChildByName('frameCount' + i)).value, isStartTargetState, false));
			}
			if(isReverse) {
				queueActions.reverse();
			}
			queue.addActions(queueActions);
			queue.start();
		}
	}
}
