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
package pl.brun.lib.display {
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 * [Event(name="newBitmap", type="pl.brun.lib.display.BitmapProviderEvent")]
	 * 
	 * created:2009-10-30 
	 * @author Marek Brun
	 */
	public class BitmapProviderEvent extends Event {

		public static const NEW_BITMAP:String = 'newBitmap';
		public var bitmap:BitmapData;

		public function BitmapProviderEvent(type:String, bitmap:BitmapData, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.bitmap = bitmap;
		}

		override public function clone():Event {
			return new BitmapProviderEvent(type, bitmap);
		}
	}
}
