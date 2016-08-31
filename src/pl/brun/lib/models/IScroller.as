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
package pl.brun.lib.models {
	import flash.events.IEventDispatcher;

	[Event(name="positionRequest", type="pl.brun.lib.events.PositionEvent")]

	/**
	 * Events:
	 *  - PositionEvent.POSITION_REQUEST
	 * 
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public interface IScroller extends IEventDispatcher {

		/**
		 * @param position form 0 to 1
		 */
		function setScroll(position:Number, visibleArea:Number, totalArea:Number):void;
	}
}
