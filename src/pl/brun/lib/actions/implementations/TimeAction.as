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
package pl.brun.lib.actions.implementations {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * created: 2009-12-02
	 * @author Marek Brun
	 */
	public class TimeAction extends EnterFrameAction {

		/**
		 * true - action can be finished externally before timer is complete
		 */
		public var isCancelable:Boolean = true;
		private var _runningTime:uint;
		private var timer:Timer;
		private var startTime:int;

		public function TimeAction(runningTime:int = 1000) {
			timer = new Timer(1, 1);
			_runningTime = runningTime;
		}

		override protected function doRunning():void {
			startTime = getTimer();
			timer.delay = runningTime;
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer_Complete);
			timer.reset();
			timer.start();
			super.doRunning();
		}

		override protected function canBeFinished():Boolean {
			return isCancelable || !timer.running;
		}

		override protected function doIdle():void {
			timer.stop();
			super.doIdle();
		}

		/**
		 * @return from 0 to 1
		 */
		public function getProgress():Number {
			return Math.max(0, Math.min(1, (getTimer() - startTime) / runningTime));
		}

		/**
		 * in ms
		 */
		public function get runningTime():uint {
			return _runningTime;
		}

		/**
		 * in ms
		 */
		public function set runningTime(value:uint):void {
			_runningTime = value;
		}

		
		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onTimer_Complete(event:TimerEvent):void {
			markAsSuccessAction();
			finish();
		}
	}
}
