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
	 * [Event(name="positionChanged", type="pl.brun.lib.events.PositionEvent")]	 * [Event(name="positionRequest", type="pl.brun.lib.events.PositionEvent")]
	 * 
	 * PositionEvent.POSITION_CHANGED	 * PositionEvent.POSITION_REQUEST
	 * 
	 * @author Marek Brun
	 */
	public class PositionEvent extends Event {

		public static const POSITION_CHANGED:String = 'positionChanged';		public static const POSITION_REQUEST:String = 'positionRequest';
		public var position:Number;

		/**
		 * @param position from 0 to 1
		 */
		public function PositionEvent(type:String, position:Number, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.position = position;
		}
		
		override public function clone():Event {
			return new PositionEvent(type, position);
		}
	}
}
