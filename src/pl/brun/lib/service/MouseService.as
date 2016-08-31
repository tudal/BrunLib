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
package pl.brun.lib.service {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.EventPlus;

	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="mouseLeave", type="pl.brun.lib.events.EventPlus")]

	[Event(name="mouseArrive", type="pl.brun.lib.events.EventPlus")]
	
	/**
	 * @author Marek Brun
	 */
	public class MouseService extends Base {
		private static var instance:MouseService;				private var isLeave:Boolean;				private var isDown:Boolean;		
		private var lastVX:Number = 0;		
		private var lastVY:Number = 0;		
		private var lastX:Number = 0;		private var lastY:Number = 0;		
		private var downX:Number = 0;		private var downY:Number = 0;
		private var lastX2:Number = 0;
		private var lastY2:Number = 0;

		public function MouseService(access:Private) {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);			isLeave = true;			isDown = false;
			lastVX = 0;
			lastVY = 0;
			lastX = root.mouseX;
			lastY = root.mouseY;
		}
		public function getIsDown():Boolean {			return isDown;		}
		public function getIsLeave():Boolean {			return isLeave;		}

		public function getDragVX():Number {
			if(isDown) { 
				return downX - root.mouseX; 
			} else { 
				return 0; 
			}
		}

		public function getDragVY():Number {
			if(isDown) { 
				return downY - root.mouseY; 
			} else { 
				return 0; 
			}
		}

		public function getLastVX():Number { 
			return lastVX; 
		}

		public function getLastVY():Number { 
			return lastVY; 
		}

		public function getX():Number { 
			return root.mouseX; 
		}

		public function getY():Number { 
			return root.mouseY; 
		}

		public function getLastX():Number { 
			return lastX; 
		}

		public function getLastY():Number { 
			return lastY; 
		}

		public function getLastX2():Number { 
			return lastX2; 
		}

		public function getLastY2():Number { 
			return lastY2; 
		}

		public static function getInstance():MouseService {
			if(instance) { 
				return instance; 
			} 
			instance = new MouseService(null); 
			return instance; 
		}

		//********************************************************************************************
		//		events for MouseService
		//********************************************************************************************	
		protected function onMouseDown(event:MouseEvent):void {			isDown = true;
		}
		protected function onMouseUp(event:MouseEvent):void {			isDown = false;		}
		protected function onMouseLeave(event:*):void {
			if(isDown) {
				isDown = false;
			}			isLeave = true;			dispatchEvent(new EventPlus(EventPlus.MOUSE_LEAVE));		}
		protected function onMouseMove(event:MouseEvent):void {
			lastVX = root.mouseX - lastX;
			lastVY = root.mouseY - lastY;
			
			lastX2 = lastX;			lastY2 = lastY;
			lastX = root.mouseX;
			lastY = root.mouseY;
						if(isLeave) {				isLeave = false;				dispatchEvent(new EventPlus(EventPlus.MOUSE_ARRIVE));			}		}
	}
}

internal class Private {
}
