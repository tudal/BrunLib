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
	 * created:2009-11-11 
	 * @author Marek Brun
	 */
	public class ChildActionEvent extends Event {

		/**
		 * Child action started running.
		 * It can be sub-sub-sub( ... and so on)-child action.
		 * 
		 */
		public static const CHILD_ACTION_RUNNING_START:String = 'childActionRunningStart';
		/**
		 * Child action finished running.
		 * It can be sub-sub-sub( ... and so on)-child action. 
		 */
		public static const CHILD_ACTION_RUNNING_FINISH:String = 'childActionRunningFinish';
		public var parent:Action;
		public var child:Action;

		public function ChildActionEvent(type:String, parent:Action, child:Action, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			
			this.parent = parent;
			this.child = child;
		}

		public function get action():Action {
			return Action(target);
		}
	}
}
