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
	 * Clip should have two frames:
	 *  - "out" gotoAndStop
	 *  - "over" gotoAndPlay (there should be "stop()" somewhere)
	 * 
	 * @author Marek Brun
	 */
	public class VisibleButtonView extends AbstractButtonView {

		private var _mc:MovieClip;

		public function VisibleButtonView(mc:MovieClip) {
			this._mc = mc;
			mc.visible = false
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		override protected function doRollOver():void {
			mc.visible = true
		}

		override protected function doRollOut():void {
			mc.visible = false
		}
	}
}
