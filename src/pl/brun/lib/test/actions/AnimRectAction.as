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
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.display.actions.MCPlayToEndAndBackAction;

	import flash.display.MovieClip;

	/**
	 * @author Marek Brun
	 */
	public class AnimRectAction extends MCPlayToEndAndBackAction {

		public function AnimRectAction(mc:MovieClip) {
			super(mc);
		}

		override protected function doChildActionStartRunning(childAction:Action):void {
			mc.addChild(MCPlayToEndAndBackAction(childAction).mc);
		}

		override protected function doChildActionFinishRunning(childAction:Action):void {
			mc.removeChild(MCPlayToEndAndBackAction(childAction).mc);
		}

		override protected function getActionByPatchName(patchName:String):Action {
			switch(patchName) {
				case 'red':
					return new AnimCircleAction(new AnimCircleRedMC());
					break;
				case 'green':
					return new AnimCircleAction(new AnimCircleGreenMC());
					break;
				case 'blue':
					return new AnimCircleAction(new AnimCircleBlueMC());
					break;
			}
			return super.getActionByPatchName(patchName);
		}
	}
}
