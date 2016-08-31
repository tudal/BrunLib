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
	import fl.controls.ComboBox;

	import pl.brun.lib.actions.ChildActionEvent;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.ArrayUtils;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**	
	 * @author Marek Brun
	 */
	public class ActionClassTargetPatchTest extends TestBase {

		private var mc:ActionClassTargetPatchTestMC;
		private var rootAction:TargetPatchRootAction;		private var labels:Array /*of String*/ = '[none],red,green,blue'.split(',');

		public function ActionClassTargetPatchTest() {
			mc = new ActionClassTargetPatchTestMC();
			holder.addChild(mc);
			
			rootAction = new TargetPatchRootAction(new Sprite());
			mc.addChild(rootAction.holder);
			rootAction.holder.x = 355;			rootAction.holder.y = 132;
			
			var i:uint;
			var loop:String;
			for(i = 0;i < labels.length;i++) {
				loop = labels[i];
				mc.combo0.addItem({label:loop});
				mc.combo1.addItem({label:loop});
				mc.combo2.addItem({label:loop});
			}
			
			mc.btnGo.addEventListener(MouseEvent.CLICK, onBtnGo_Click);			mc.btnGoRandom.addEventListener(MouseEvent.CLICK, onBtnGoRandom_Click);
			
			rootAction.addEventListener(ChildActionEvent.CHILD_ACTION_RUNNING_START, onRootAction_ChildActionRunningStart);
			rootAction.addEventListener(ChildActionEvent.CHILD_ACTION_RUNNING_FINISH, onRootAction_ChildActionRunningFinish);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onBtnGo_Click(event:MouseEvent):void {
			var targetPatch:Array /*of String*/= [];
			if(mc.combo0.selectedIndex) {
				targetPatch.push(mc.combo0.selectedLabel);
				if(mc.combo1.selectedIndex) {
					targetPatch.push(mc.combo1.selectedLabel);
					if(mc.combo2.selectedIndex) {
						targetPatch.push(mc.combo2.selectedLabel);
					}
				}
			}
			dbg.log('targetPatch:' + targetPatch.join(', '));
			//enterDebugger();
			rootAction.setTargetPatch(targetPatch);
		}

		private function onBtnGoRandom_Click(event:MouseEvent):void {
			var targetPatch:Array /*of String*/= [];
			
			var i:uint;
			var index:uint;
			var wasNone:Boolean;
			for(i = 0;i < 3;i++) {
				index = ArrayUtils.getRandomIndex(labels);
				ComboBox(mc['combo' + i]).selectedIndex = index;
				if(!index) {
					wasNone = true;
				}
				if(!wasNone) {
					targetPatch.push(labels[index]);
				}
			}
			
			dbg.log('targetPatch:' + targetPatch.join(', '));
			rootAction.setTargetPatch(targetPatch);
		}

		private function onRootAction_ChildActionRunningFinish(event:ChildActionEvent):void {
			dbg.log('ChildActionRunningFinish patch:' + rootAction.getCurrentPatch());
		}

		private function onRootAction_ChildActionRunningStart(event:ChildActionEvent):void {
			dbg.log('ChildActionRunningStart patch:' + rootAction.getCurrentPatch());
		}
	}
}
