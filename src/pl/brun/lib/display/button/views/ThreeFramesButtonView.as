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
	import flash.display.MovieClip;

	/**
	 * 
	 * Clip should have three frames:
	 *  - 1: no rollover state
	 *  - 2: rollover state	 *  - 3: press state
	 * 
	 * @author Marek Brun
	 */
	public class ThreeFramesButtonView extends AbstractButtonView {
		private var _mc:MovieClip;
		private var release:*;
		private var press:*;
		private var over:*;
		private var out:*;

		public function ThreeFramesButtonView(mc:MovieClip, out:* = 1, over:* = 2, press:* = 3, release:* = 2) {
			this.out = out;
			this.over = over;
			this.press = press;
			this.release = release;
			this._mc = mc;
			mc.gotoAndStop(out);
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		override protected function doRollOver():void {
			mc.gotoAndStop(over);
		}

		override protected function doPress():void {
			mc.gotoAndStop(press);
		}

		override protected function doRelease():void {
			mc.gotoAndStop(release);
		}

		override protected function doRollOut():void {
			mc.gotoAndStop(out);
		}
	}
}
