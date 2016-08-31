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

	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	[Event(name="enterNewFrame", type="pl.brun.lib.display.tools.MCNewFrameEnterEvent")]

	/**
	 * @author Marek Brun
	 */
	public class MCNewFrameEnterDispatcher extends Base {

		private static const servicedObjects:Dictionary = new Dictionary(true);
		private var mc:MovieClip;

		public function MCNewFrameEnterDispatcher(access:Private, mc:MovieClip) {
			this.mc = mc;
			var framesDispatcher:MCFrameEnterDispatcher = MCFrameEnterDispatcher.forInstance(mc);
			var i:uint;
			for(i = 0;i < mc.totalFrames;i++) {
				framesDispatcher.addFrameListener(i + 1, onNewFrame);
			}
		}

		static public function forInstance(mc:MovieClip):MCNewFrameEnterDispatcher {
			if(!servicedObjects[mc]) {
				servicedObjects[mc] = new MCNewFrameEnterDispatcher(null, mc);
			}
			return servicedObjects[mc];
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onNewFrame():void {
			dispatchEvent(new MCNewFrameEnterEvent(MCNewFrameEnterEvent.ENTER_NEW_FRAME, mc));
		}
	}
}

internal class Private {
}
