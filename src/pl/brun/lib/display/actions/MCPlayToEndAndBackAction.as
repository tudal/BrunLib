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
package pl.brun.lib.display.actions {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.models.IMCOperator;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author Marek Brun
	 */
	public class MCPlayToEndAndBackAction extends Action implements IMCOperator {

		private var _mc:MovieClip;
		private var playToEndAction:MCPlayToAction;
		private var playToStartAction:MCPlayToAction;

		public function MCPlayToEndAndBackAction(mc:MovieClip, startFrame:uint = 1, endFrame:uint = 0) {
			dbg.registerInDisplay(mc);			playToEndAction = new MCPlayToAction(mc, endFrame == 0 ? mc.totalFrames : endFrame);
			playToStartAction = new MCPlayToAction(mc, startFrame);
			mc.gotoAndStop(1);
			_mc = mc;
		}

		override protected function getInitialAction():Action {
			return playToEndAction;
		}

		override protected function getEndingAction():Action {
			return playToStartAction;
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		public function get display():DisplayObject {
			return _mc;
		}
	}
}
