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

	[Event(name="positionChanged", type="pl.brun.lib.events.PositionEvent")]

	/**
	 * Events:
	 *  - PositionEvent.POSITION_CHANGED
	 * 
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public interface IScrollable extends IEventDispatcher {

		function getScroll():Number;

		function setScroll(scroll:Number):void;

		function getVisibleArea():Number;
		function getTotalArea():Number;
	}
}
