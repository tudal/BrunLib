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
package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="selectRequest", type="pl.brun.lib.events.SelectIndexEvent")]
	 * [Event(name="select", type="pl.brun.lib.events.SelectIndexEvent")]
	 * 
	 * SelectEvent.SELECT_REQUEST
	 * SelectEvent.SELECT
	 * 
	 * 
	 * created: 2009-12-16
	 * @author Marek Brun
	 */
	public class SelectIndexEvent extends Event {

		public static const DESELECT_REQUEST:String = 'deselectRequest';
		public static const DESELECT:String = 'deselect';
		
		public static const SELECT_REQUEST:String = 'selectRequest';
		public static const SELECT:String = 'select';
		
		/**
		 * index of choosed position (ex. 5 button from menu, so index is 4 because it is counted from zero)
		 */
		public var index:uint;

		public function SelectIndexEvent(type:String, index:uint) {
			super(type);
			this.index = index;
		}

		override public function clone():Event {
			return new SelectIndexEvent(type, index);
		}
	}
}
