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
package pl.brun.lib.test {
	import pl.brun.lib.Base;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Marek Brun
	 */
	public class SomeClassToDispose extends Base {

		public var obj:Object = {};
		private var timer:Timer;

		public function SomeClassToDispose() {
			timer = new Timer(2000);
			addEventSubscription(timer, TimerEvent.TIMER, onTimer_Tick);
			timer.start();
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onTimer_Tick(event:TimerEvent):void {
			dbg.log('onTimer_Tick()');
			dispatchEvent(new SomeClassToDisposeEvent(SomeClassToDisposeEvent.TICK));
		}
	}
}
