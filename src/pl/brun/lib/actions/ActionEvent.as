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
package pl.brun.lib.actions {
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class ActionEvent extends Event {

		/**
		 * For every implementation running start will be different,
		 * so please write description what it exactly is (what
		 * is the runnig state).
		 */
		public static const RUNNING_START:String = 'runningStart';
		/**
		 * When there's initial action - occurs after that action is finished
		 * If there's no initial action - occurs just after running start
		 * 
		 * In other words - action is fully started.
		 * 
		 * WARNING: If betwen running start and middle state finish was requested, then
		 * action does not enter the middle state.
		 */
		public static const RUNNING_MIDDLE_ENTER:String = 'runningMiddleEnter';
		/**
		 * Last child from target patch just started running.
		 * 
		 * WARNING: this event is dipatched from all actions in patch.
		 */
		public static const TARGET_PATCH_COMPLETE:String = 'targetPatchComplete';
		/**
		 * Action is just started to finish, so we go out of middle state. 
		 */
		public static const RUNNING_MIDDLE_OUT:String = 'runningMiddleOut';
		/**
		 * For every implementation running finish will be different,
		 * so please write description what it exactly is (what
		 * is idle state).
		 */
		public static const RUNNING_FINISH:String = 'runningFinish';
		public static const RUNNING_FLAG_CHANGED:String = 'runningFlagChanged';

		public function ActionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		public function get action():Action {
			return Action(target);
		}
	}
}