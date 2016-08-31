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

	import flash.display.Sprite;

	/**
	 * @author Marek Brun
	 */
	public class TargetPatchRootAction extends Action {

		private var _holder:Sprite;

		public function TargetPatchRootAction(holder:Sprite) {
			dbg.registerInDisplay(holder);
			this._holder = holder;
		}

		public function get holder():Sprite { 
			return _holder; 
		}

		override protected function doChildActionStartRunning(childAction:Action):void {
			holder.addChild(MCPlayToEndAndBackAction(childAction).mc);
		}

		override protected function doChildActionFinishRunning(childAction:Action):void {
			holder.removeChild(MCPlayToEndAndBackAction(childAction).mc);
		}

		override protected function getActionByPatchName(patchName:String):Action {
			switch(patchName) {
				case 'red':
					return new AnimRectAction(new AnimRectRedMC());
					break;
				case 'green':
					return new AnimRectAction(new AnimRectGreenMC());
					break;
				case 'blue':
					return new AnimRectAction(new AnimRectBlueMC());
					break;
			}
			return super.getActionByPatchName(patchName);
		}

		override protected function doEndPatchRepeat(patchName:String):void {
			dbg.log('doEndPatchRepeat(' + dbg.link(arguments[0], true) + ')');
		}
	}
}
