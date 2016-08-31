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
package pl.brun.lib.test.display.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.display.tools.MCFrameEnterDispatcher;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class FramesReciverController extends Base {

		private var mcAnimFrames:MCFrameEnterDispatcher;
		private var mc:FramesReciverControllerMC;
		private var isRecivingGreen:Boolean;
		private var isRecivingRed:Boolean;
		private var mc_anim:MovieClip;		public var id:uint;

		public function FramesReciverController(mc:FramesReciverControllerMC, mc_anim:MovieClip) {
			this.mc = mc;
			this.mc_anim = mc_anim;
			
			mcAnimFrames = MCFrameEnterDispatcher.forInstance(mc_anim);
			
			mc.btnGreen.addEventListener(MouseEvent.CLICK, onBtnGreen_Click);			mc.btnRed.addEventListener(MouseEvent.CLICK, onBtnRed_Click);
			
			drawReciverButtonsLabels();
		}

		private function drawReciverButtonsLabels():void {
			mc.btnGreen.label = 'turn ' + (isRecivingGreen ? 'off' : 'onn') + ' reciving "green"';			mc.btnRed.label = 'turn ' + (isRecivingRed ? 'off' : 'onn') + ' reciving "red"';
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onMCAnimFrames_GreenFrameEnter():void {
			dbg.log('onMCAnimFrames_GreenFrameEnter()');
		}

		private function onMCAnimFrames_RedFrameEnter():void {
			dbg.log('onMCAnimFrames_RedFrameEnter()');
		}

		private function onBtnRed_Click(event:MouseEvent):void {
			isRecivingRed = !isRecivingRed;
			if(isRecivingRed) {
				mcAnimFrames.addFrameListener(DisplayUtils.getFrameByLabel(mc_anim, 'red'), onMCAnimFrames_RedFrameEnter);
			} else {
				mcAnimFrames.removeFrameListener(DisplayUtils.getFrameByLabel(mc_anim, 'red'), onMCAnimFrames_RedFrameEnter);
			}
			drawReciverButtonsLabels();
		}

		private function onBtnGreen_Click(event:MouseEvent):void {
			isRecivingGreen = !isRecivingGreen;
			if(isRecivingGreen) {
				mcAnimFrames.addFrameListener(DisplayUtils.getFrameByLabel(mc_anim, 'green'), onMCAnimFrames_GreenFrameEnter);
			} else {
				mcAnimFrames.removeFrameListener(DisplayUtils.getFrameByLabel(mc_anim, 'green'), onMCAnimFrames_GreenFrameEnter);
			}
			drawReciverButtonsLabels();
		}
	}
}
