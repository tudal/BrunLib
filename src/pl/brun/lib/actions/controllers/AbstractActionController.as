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
package pl.brun.lib.actions.controllers {
	import pl.brun.lib.actions.Action;

	/**
	 * @author Marek Brun
	 */
	public class AbstractActionController extends Action {

		private var _controlledAction:Action;

		public function AbstractActionController(controlledAction:Action) {
			_controlledAction = controlledAction;
		}

		public function get controlledAction():Action {
			return _controlledAction;
		}

		override protected function canBeRestarted():Boolean {
			return false;
		}

		override protected function isDisposeAfterFinishWithNoRestart():Boolean {
			return true;
		}
	}
}
