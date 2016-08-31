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
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author Marek Brun
	 */
	public class MCPlayToIniMidEnd extends Action implements IMCOperator {

		private var _mc:MovieClip;
		private var animIni:MCPlayForwardFromToAction;
		private var animEnd:MCPlayForwardFromToAction;

		public function MCPlayToIniMidEnd(mc:MovieClip, isStop:Boolean = true, ini:String = 'ini', mid:String = 'mid', end:String = 'end', toEnd:String = null) {
			dbg.registerInDisplay(mc);
			this._mc = mc;
			
			if(toEnd == null) {
				toEnd = mid;
			}
			
			if(isStop) {
				mc.gotoAndStop(ini);
			}
			
			var frameIni:uint = DisplayUtils.getFrameByLabel(mc, ini);			var frameMid:uint = DisplayUtils.getFrameByLabel(mc, mid);			var frameEnd:uint = DisplayUtils.getFrameByLabel(mc, end);			var frameToEnd:uint = DisplayUtils.getFrameByLabel(mc, toEnd);			
			animIni = new MCPlayForwardFromToAction(mc, frameIni, frameMid);			animEnd = new MCPlayForwardFromToAction(mc, frameToEnd, frameEnd);
		}

		override protected function getInitialAction():Action {
			return animIni;
		}

		override protected function getEndingAction():Action {
			return animEnd;
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		public function get display():DisplayObject { 
			return _mc; 
		}

		override public function dispose():void {
			DisplayUtils.disposeDisplay(mc);
			super.dispose();
		}
	}
}
