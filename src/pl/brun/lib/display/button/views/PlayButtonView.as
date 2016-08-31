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
	 * @author Marek Brun
	 */
	public class PlayButtonView extends AbstractButtonView {

		private var _mc:MovieClip;
		private var playFrom:*;

		public function PlayButtonView(mc:MovieClip, playFrom:*=1) {
			this.playFrom = playFrom;
			this._mc = mc;
		}

		public function get mc():MovieClip { 
			return _mc;
		}

		override protected function doRollOver():void {
			mc.gotoAndPlay(playFrom);
		}
	}
}
