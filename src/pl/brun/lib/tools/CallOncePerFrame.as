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
package pl.brun.lib.tools {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Take care of calling specifed functiononly once per frame.
	 * 
	 * Simplest using, just paste this code to begginig of the function:
	//		private function draw():void {
	//			if(!CallOncePerFrame.call(draw)) {
	//				return;
	//			}
	//		} 
	 * 
	 * 
	 * @author Marek Brun
	 */
	public class CallOncePerFrame {

		static private var instance:CallOncePerFrame;
		private var display:Sprite;
		private const dictFunction_IsCalled:Dictionary = new Dictionary();
		private const dictFunction_ToCallInNext:Dictionary = new Dictionary();
		private var isNowInternalCall:Boolean;

		public function CallOncePerFrame(access:Private) {
			display = new Sprite();
			clear();
		}

		private function clear():void {
			var v:*
			for(v in dictFunction_IsCalled){
				delete dictFunction_IsCalled[v]
			}
			for(v in dictFunction_ToCallInNext){
				delete dictFunction_ToCallInNext[v]
			}
		}

		static public function call(func:Function):Boolean {
			return getInstance()._call(func);
		}

		private function _call(func:Function):Boolean {
			if(isNowInternalCall) {
				return true;
			}
			if(dictFunction_IsCalled[func]) {
				dictFunction_ToCallInNext[func] = true;
				return false;
			}
			dictFunction_IsCalled[func] = true;
			
			isNowInternalCall = true;
			func();
			isNowInternalCall = false;
			
			display.addEventListener(Event.ENTER_FRAME, onDisplay_EnterFrame);
			return false;
		}

		static private function getInstance():CallOncePerFrame {
			if(instance) { 
				return instance; 
			}
			instance = new CallOncePerFrame(null);
			return instance;
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onDisplay_EnterFrame(event:Event):void {
			isNowInternalCall = true;
			var func:Function;
			for(var v:* in dictFunction_ToCallInNext) {
				func = v;
				func();
			}
			isNowInternalCall = false;
			clear();
			display.removeEventListener(Event.ENTER_FRAME, onDisplay_EnterFrame);
		}
	}
}

internal class Private {
}
