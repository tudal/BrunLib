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
	import pl.brun.lib.Base;
	import pl.brun.lib.util.ArrayUtils;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * MCFrameEnterEventDispatcher is dispatching events about entering in specific
	 * frame. Detecting frames is based on addFrameScript.
	 * 
	 * It's often usable if you don't sure if multiple classes will be using
	 * addFrameScript on the same MovieClip.
	 * 
	 * 
	 * @author Marek Brun
	 */
	public class MCFrameEnterDispatcher extends Base {

		private var _mc:MovieClip;
		/**
		 * key:uint
		 * value:Array of Function
		 */		private var dictFrameScript_Handlers:Dictionary = new Dictionary(true);

		public function MCFrameEnterDispatcher(access:Private, mc:MovieClip) {
			this._mc = mc;
		}

		public function addFrameListenerByLabel(label:String, handler:Function):void {
			addFrameListener(DisplayUtils.getFrameByLabel(mc, label), handler);
		}

		public function addFrameListener(frame:uint, handler:Function):void {
			if(!dictFrameScript_Handlers[frame]) {
				dictFrameScript_Handlers[frame] = [];
				mc.addFrameScript(frame - 1, onFrameScript);
			}
			ArrayUtils.pushUnique(dictFrameScript_Handlers[frame], handler);
		}

		public function removeFrameListenerByLabel(label:String, handler:Function):void {
			removeFrameListener(DisplayUtils.getFrameByLabel(mc, label), handler);
		}

		public function removeFrameListener(frame:uint, handler:Function):void {
			if(!dictFrameScript_Handlers[frame]) {
				return;
			}
			ArrayUtils.remove(dictFrameScript_Handlers[frame], handler);
		}

		public function get mc():MovieClip { 
			return _mc;
		}

		private static const servicedObjects:Dictionary = new Dictionary(true);

		static public function forInstance(mc:MovieClip):MCFrameEnterDispatcher {
			if(!servicedObjects[mc]) {
				servicedObjects[mc] = new MCFrameEnterDispatcher(null, mc);
			}
			return servicedObjects[mc];
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onFrameScript():void {
			if(!dictFrameScript_Handlers[mc.currentFrame]) { 
				return; 
			}
			var handlers:Array /*of Function*/= dictFrameScript_Handlers[mc.currentFrame];
			var i:uint;
			for(i = 0;i < handlers.length;i++) {
				handlers[i]();
			}
		}
	}
}

internal class Private {
}