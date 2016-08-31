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
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.managers.RootProvider;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	/**
	 * @author Marek Brun
	 */
	public class FrameDelayCall {

		static private var instance:FrameDelayCall;
		private var toCall:Array;

		public function FrameDelayCall(access:Private) {
			toCall = [];
		}

		public function addMethod_(func:Function, aterFrames:uint = 1, args:Array = null):void {
			toCall.push([func, aterFrames, args]);
			RootProvider.getRoot().addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		public function addMethod2_(obj:IDisposable, func:Function, aterFrames:uint = 1, args:Array = null):void {
			toCall.push([func, aterFrames, args, obj]);
			RootProvider.getRoot().addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		static public function getInstance():FrameDelayCall {
			if(!instance) { 
				instance = new FrameDelayCall(null);
			} 
			return instance; 
		}

		static public function addCall(func:Function, afterFrames:uint = 1, args:Array = null):void {
			if(args && args.length > 4) {
				throw new IllegalOperationError("Max supported number of arguments are 4 (you passed " + args.length + ")");
			}
			getInstance().addMethod_(func, afterFrames, args);
		}

		static public function addCall2(obj:IDisposable, func:Function, afterFrames:uint = 1, args:Array = null):void {
			if(args && args.length > 4) {
				throw new IllegalOperationError("Max supported number of arguments are 4 (you passed " + args.length + ")");
			}
			getInstance().addMethod2_(obj, func, afterFrames, args);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			var i:uint;
			var iterat:Array;
			for(i = 0;i < toCall.length;i++) {
				iterat = toCall[i];
				iterat[1]--;
				if(iterat[1] == 0) {
					if(iterat[3] && IDisposable(iterat[3]).isDisposed){
						
					}else{
						if(iterat[2]) {
							switch(iterat[2].length) {
								case 0:
									iterat[0]();
									break;
								case 1:
									iterat[0](iterat[2][0]);
									break;
								case 2:
									iterat[0](iterat[2][0], iterat[2][1]);
									break;
								case 3:
									iterat[0](iterat[2][0], iterat[2][1], iterat[2][2]);
									break;
								case 4:
									iterat[0](iterat[2][0], iterat[2][1], iterat[2][2], iterat[2][3]);
									break;
							}
						} else {
							iterat[0]();
						}
					}
					toCall.splice(i, 1); 
					i--;
				}
			}
			if(!toCall.length) {
				RootProvider.getRoot().removeEventListener(Event.ENTER_FRAME, onStage_EnterFrame);
			}
		}
	}
}

internal class Private {
}