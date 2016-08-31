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
package pl.brun.lib.display.button.views {
	import pl.brun.lib.display.tools.MCFrameEnterDispatcher;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * The button clip should have frames:
	 *  - "ini" idle state and a beginig of rollover animation
	 *  - "mid" frame where animation stops if there's (stil) rollover or press state
	 *  - "end" frame where animation ends
	 * 
	 * 
	 * @author Marek Brun
	 */
	public class IniMidEndButtonView extends AbstractButtonView {

		private var _mc:MovieClip;
		private var ini:String;

		public function IniMidEndButtonView(mc:MovieClip, ini:String = 'ini', mid:String = 'mid', end:String = 'end') {
			this.ini = ini;
			this._mc = mc;
			
			if(getFrameByLabel(mc, ini) == 1) {
				mc.gotoAndStop(ini);
			}
			
			var fed:MCFrameEnterDispatcher = MCFrameEnterDispatcher.forInstance(mc);
			
			fed.addFrameListenerByLabel(ini, onMC_EnterIniFrame);			fed.addFrameListenerByLabel(mid, onMC_EnterMidFrame);			fed.addFrameListenerByLabel(end, onMC_EnterEndFrame);
		}

		public function get mc():MovieClip { 
			return _mc;
		}

		override protected function doRollOver():void {
			mc.play();
		}

		override protected function doRollOut():void {
			mc.play();
		}

		public static function getFrameByLabel(mc:MovieClip, targetLabel:String):int {
			var i:uint;
			var loopLabel:FrameLabel;
			for(i = 0;i < mc.currentLabels.length;i++) {
				loopLabel = mc.currentLabels[i];
				if(loopLabel.name === targetLabel) {
					return loopLabel.frame;
				}
			}
			return 0;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onMC_EnterIniFrame():void {
			if(model.isOver) {
				mc.play();
			} else {
				mc.stop();
			}
		}

		private function onMC_EnterMidFrame():void {
			if(model.isOver) {
				mc.stop();
			}
		}

		private function onMC_EnterEndFrame():void {
			mc.gotoAndPlay(ini);
		}
	}
}
