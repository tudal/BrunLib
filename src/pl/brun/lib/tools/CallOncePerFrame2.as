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
	import pl.brun.lib.Base;
	import pl.brun.lib.IDisposable;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * Take care of calling specifed functiononly once per frame.
	 * 
	 * Simplest using, just paste this code to begginig of the function:
	// private function draw():void {
	// if(!CallOncePerFrame.call(draw)) {
	// return;
	// }
	// } 
	 * 
	 * 
	 * @author Marek Brun
	 */
	public class CallOncePerFrame2 extends Base {
		private static var ins:CallOncePerFrame2;
		private static const dictFunc_Obj:Dictionary = new Dictionary();
		private static const funcs:Vector.<Function> = new <Function>[];
		private static var isCalling:Boolean;

		public function CallOncePerFrame2() {
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
		}

		private function onStage_EnterFrame(event:Event):void {
			flush_()
		}

		private function flush_():void {
			isCalling = true
			var func:Function
			var obj:IDisposable
			while (funcs.length) {
				func = funcs.pop()
				obj = IDisposable(dictFunc_Obj[func])
				if (!obj.isDisposed)  func();
				delete dictFunc_Obj[func]
			}
			isCalling = false
		}

		public static function init():void {
			if (!ins) ins = new CallOncePerFrame2();
		}

		public static function call(obj:IDisposable, func:Function):Boolean {
			if (isCalling || dictFunc_Obj[func]) return false;
			ins.call_(obj, func)
			return true
		}

		private function call_(obj:IDisposable, func:Function):void {
			dictFunc_Obj[func] = obj
			funcs.push(func)
		}

		public static function flush():void {
			ins.flush_()
		}
	}
}