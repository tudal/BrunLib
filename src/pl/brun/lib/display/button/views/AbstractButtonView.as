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
	import pl.brun.lib.Base;
	import pl.brun.lib.display.button.ButtonModel;

	/**
	 * @author Marek Brun
	 */
	public class AbstractButtonView extends Base {

		protected var model:ButtonModel;
		protected var isOver:Boolean;

		public function AbstractButtonView() {
		}

		public function setModel(model:ButtonModel):void {
			this.model = model;
		}

		/*abstract*/
		protected function doRollOver():void {
		}

		/*abstract*/
		protected function doPress():void {
		}

		/*abstract*/
		protected function doRelease():void {
		}

		/*abstract*/
		protected function doRollOut():void {
		}

		/*abstract*/
		protected function doFreeze():void {
		}

		/*abstract*/
		protected function doUnfreeze():void {
		}

		/*abstract*/
		protected function doDisabled():void {
		}

		/*abstract*/
		protected function doEnabled():void {
		}

		public function setRollOver():void {
			isOver = true
			doRollOver()
		}

		public function setRollOut():void {			isOver = false
			doRollOut()
		}

		public function setPress():void {
			doPress();
		}

		public function setRelease():void {
			doRelease();
		}

		public function setFreeze():void {
			doFreeze();
		}

		public function setUnfreeze():void {
			doUnfreeze();
		}

		public function setDisabled():void {
			doDisabled();
		}

		public function setEnabled():void {
			doEnabled();
		}
	}
}
