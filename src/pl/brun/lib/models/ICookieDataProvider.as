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

	/**
	 * @author Marek Brun
	 */
	public interface ICookieDataProvider extends IEventDispatcher {

		/**
		 * Initial data (ex. {volume:0.5}).
		 */
		function getSharedObjectInitData():Object;

		/**
		 * Executed only once - when EasyCookie instance is created
		 */
		function applySharedObjectData(data:Object):void;

		/**
		 * After every calling of EasyCookie.flush() current data is collected
		 * and passed to shared object (ex. {volume:0.1}).
		 */
		function getSharedObjectData():Object;
	}
}
