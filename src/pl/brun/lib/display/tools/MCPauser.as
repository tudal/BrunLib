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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * MCPauser stops playing of MovieClip timeline, and all its children MovieClips (recurency).
	 * 
	 * Before MC is paused, MCPauser wait one frame to see if MC is currently playing.
	 * After "resume", MC is played again if it was played before. 
	 * 
	 * Using:
	 * MCPauser.forInstance(mc).pause();
	 * MCPauser.forInstance(mc).resume();
	 * MCPauser.forInstance(mc).pause(false); //don't pause child clips
	 * MCPauser.forInstance(mc).resume(false); //don't resume child clips
	 * 
	 * @author Marek Brun
	 */
	public class MCPauser extends EventDispatcher {

		public var isPlayedBeforePause:Boolean;
		private static const servicedObjects:Dictionary = new Dictionary(true);
		private var mc:MovieClip;
		private var _isPaused:Boolean;
		private var frameBeforePause:int;
		private var isFirstCheck:Boolean;

		public function MCPauser(access:Private, mc:MovieClip) {
			this.mc = mc;
		}

		public function pause(isPauseChildren:Boolean = true):void {
			if(_isPaused) { 
				return; 
			}
			_isPaused = true;
			if(isPauseChildren) {
				var i:uint;
				for(i = 0;i < mc.numChildren;i++) {
					if(mc.getChildAt(i) is MovieClip) {
						MCPauser.forInstance(MovieClip(mc.getChildAt(i))).pause();
					}
				}
			}
			
			if(mc.totalFrames > 1) {
				frameBeforePause = mc.currentFrame;
				isFirstCheck = true;
				mc.addEventListener(Event.ENTER_FRAME, onEF_AfterPause);
			}
		}

		public function resume(isUnpauseChildren:Boolean = true):void {
			if(!isPaused) { 
				return; 
			}
			_isPaused = false;
			mc.removeEventListener(Event.ENTER_FRAME, onEF_AfterPause);
			if(isUnpauseChildren) {
				var i:uint;
				for(i = 0;i < mc.numChildren;i++) {
					if(mc.getChildAt(i) is MovieClip) {
						MCPauser.forInstance(MovieClip(mc.getChildAt(i))).resume();
					}
				}
			}
			if(isPlayedBeforePause) {
				mc.play();
			}
		}

		/**
		 * Only getter.
		 */
		public function get isPaused():Boolean {
			return _isPaused;
		} 

		/**
		 * Garbage collector secure way to link two classes.
		 */
		static public function forInstance(mc:MovieClip):MCPauser {
			if(!servicedObjects[mc]) {
				servicedObjects[mc] = new MCPauser(null, mc);
			}
			return servicedObjects[mc];
		}

		//----------------------------------------------------------------------
		//		handlers
		//----------------------------------------------------------------------
		protected function onEF_AfterPause(event:Event):void {
			isPlayedBeforePause = mc.currentFrame != frameBeforePause;
			if(!isPlayedBeforePause && isFirstCheck) {
				isFirstCheck = false;
				return;
			}
			isFirstCheck = false;
			mc.removeEventListener(Event.ENTER_FRAME, onEF_AfterPause);
			mc.stop();
		}
	}
}

internal class Private {
}