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
	import pl.brun.lib.display.ui.tooltip.Tooltip;

	import flash.display.MovieClip;

	/**
	 * created:2009-10-27 
	 * @author Marek Brun
	 */
	public class TooltipButtonView extends AbstractButtonView {

		private var _mc:MovieClip;
		private var tooltip:Tooltip;
		private var text:String;
		private var align:Number;

		public function TooltipButtonView(mc:MovieClip, tooltip:Tooltip, text:String, align:Number = -1) {
			this._mc = mc;
			this.tooltip = tooltip;
			this.text = text;
			this.align = align;
		}

		override protected function doRollOver():void {
			if(model.isFreeze) { 
				return;
			}
			if(align == -1) {
				tooltip.setText(text, true, true);
			} else {				tooltip.setAlign(align);
				tooltip.setText(text, true);
			}
		}

		override protected function doRollOut():void {
			tooltip.setIsVisible(false);
		}

		public function get mc():MovieClip { 
			return _mc;
		}
	}
}
