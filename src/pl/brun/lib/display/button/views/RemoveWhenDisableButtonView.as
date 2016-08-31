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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * created:2009-11-20
	 * @author Marek Brun
	 */
	public class RemoveWhenDisableButtonView extends AbstractButtonView {

		private var display:DisplayObject;
		private var parent:DisplayObjectContainer;

		public function RemoveWhenDisableButtonView(display:DisplayObject, parent:DisplayObjectContainer = null) {
			parent = parent ? parent : display.parent;
			this.display = display;
		}

		override protected function doDisabled():void {
			if(model.isFreeze) {
				return;
			}
			parent = display.parent;
			parent.removeChild(display);
		}

		override protected function doEnabled():void {
			display.alpha = 1;
			parent.addChild(display);
		}
	}
}
