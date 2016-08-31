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
package pl.brun.lib.display.tools {
	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class MCNewFrameEnterEvent extends Event {

		public static const ENTER_NEW_FRAME:String = 'enterNewFrame';
		public var mc:MovieClip;

		public function MCNewFrameEnterEvent(type:String, mc:MovieClip, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.mc = mc;
		}

		override public function clone():Event {
			return new MCNewFrameEnterEvent(type, mc);
		}
	}
}
