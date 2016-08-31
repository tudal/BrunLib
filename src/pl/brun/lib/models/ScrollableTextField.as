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
	import pl.brun.lib.Base;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.events.Event;
	import flash.text.TextField;

	[Event(name="positionChanged", type="pl.brun.lib.events.PositionEvent")]

	/**
	 * Events:
	 *  - PositionEvent.POSITION_CHANGED
	 *  
	 * WARNING: SCROLL event is sometimes not dispatched after resize of texfield
	 * so please use "afterChange" method after every resize
	 * 
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class ScrollableTextField extends Base implements IScrollable {

		private var tf:TextField;
		private var lastMaxScrollV:int;
		private var lastScrollV:int;
		private var uncountScrollCheck:int;
		private var lastBottomScrollV:int;

		public function ScrollableTextField(tf:TextField) {
			this.tf = tf;
			tf.addEventListener(Event.SCROLL, onTextField_Scroll, false, 0, true);
			FrameDelayCall.addCall(afterChange, 3);
		}

		public function afterChange():void {
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, getScroll()));
			
			//flash player bug fix with dispaching scroll 
			lastMaxScrollV = tf.maxScrollV;
			lastScrollV = tf.scrollV;
			lastBottomScrollV = tf.bottomScrollV;
			uncountScrollCheck = 2;
			
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		public function getScroll():Number {
			if(tf.scrollV == 1) { 
				return 0; 
			}
			return (tf.scrollV - 1) / (tf.maxScrollV - 1);
		}

		public function setScroll(scroll:Number):void {
			if(getScroll() == scroll || tf.maxScrollV == 1) {
				return;
			}
			tf.scrollV = Math.round(1 + (tf.maxScrollV - 1) * scroll);
		}

		public function getVisibleArea():Number {
			if(tf.maxScrollV == 1) {
				return 1;
			}
			var visible:Number = tf.bottomScrollV - tf.scrollV + 1;
			return visible;
		}

		public function getTotalArea():Number {
			if(tf.maxScrollV == 1) {
				return 1;
			}
			var visible:Number = tf.bottomScrollV - tf.scrollV + 1;
			var total:Number = tf.maxScrollV + visible - 1;
			return total;
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onTextField_Scroll(event:Event):void {
			afterChange();
		}

		private function onStage_EnterFrame(event:Event):void {
			if(lastMaxScrollV == tf.maxScrollV && lastScrollV == tf.scrollV && lastBottomScrollV==tf.bottomScrollV) {
				//no fix
				uncountScrollCheck--;
				if(uncountScrollCheck <= 0) {
					root.removeEventListener(Event.ENTER_FRAME, onStage_EnterFrame);
				}
			} else {
				//fix 
				lastMaxScrollV = tf.maxScrollV;
				lastScrollV = tf.scrollV;				lastBottomScrollV = tf.bottomScrollV;
				dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, getScroll()));
			}
		}
	}
}