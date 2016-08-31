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
package pl.brun.lib.managers {
	import pl.brun.lib.tools.CallOncePerFrame2;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author Marek Brun
	 */
	public class StageProvider {
		static private var instance:StageProvider;
		private var stage:Stage;
		private var lastFrameTime:int;
		private var lastFrameDuration:int;

		public function StageProvider(access:Private, stage:Stage) {
			this.stage = stage;
			lastFrameTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);
		}

		static public function getLastFrameDuration():uint {
			return getInstance()._getLastFrameDuration();
		}

		static public function getStage():Stage {
			return getInstance()._getStage();
		}

		private function _getStage():Stage {
			return stage;
		}

		private function _getLastFrameDuration():uint {
			return lastFrameDuration;
		}

		static public function getInstance():StageProvider {
			if (instance) {
				return instance;
			} else {
				throw new Error('Before calling StageProvider.getInstance() please call StageProvider.init()');
			}
		}

		static public function init(stage:Stage):void {
			if (instance) {
				return;
			} else {
				instance = new StageProvider(null, stage);
				CallOncePerFrame2.init()
			}
		}

		// --------------------------------------------------------------------------
		// handlers
		// --------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			lastFrameDuration = getTimer() - lastFrameTime;
			lastFrameTime = getTimer();
		}
	}
}
internal class Private {
}