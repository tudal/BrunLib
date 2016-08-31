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
package pl.brun.lib.display.button {
	import flash.events.Event;

	/**
	 * created: 2009-12-06
	 * @author Marek Brun
	 */
	public class ButtonEvent extends Event {

		public static const OVER:String = 'over';		public static const MOVE_OVER:String = 'mouseOver';		public static const PRESS:String = 'press';		public static const DRAG_MOVE:String = 'dragMove';		public static const DRAG_OUT:String = 'dragOut';		public static const DRAG_OVER:String = 'dragOver';		public static const RELEASE:String = 'release';		public static const RELEASE_OVER:String = 'releaseOver';		public static const RELEASE_OUTSIDE:String = 'releaseOutside';		public static const OUT:String = 'out';		public static const DISABLE:String = 'disable';		public static const ENABLE:String = 'enable';
		public static const FREEZE:String = 'freeze';
		public static const UNFREEZE:String = 'unfreeze';

		public function ButtonEvent(type:String) {
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event {
			return new ButtonEvent(type);
		}
	}
}
