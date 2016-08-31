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
package pl.brun.lib.display.libraryItems {
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * Since AS don't provide information about created instances on the stage,
	 * it can be problem to found out that child clip was created while timeline playing.
	 * 
	 * With using this class as base class you can easly detect created clips by
	 * bubbled event - MCDetectEvent.CREATED
	 * 
	 * pl.brun.lib.display.libraryItems.MCDetectable
	 * @author Marek Brun
	 */
	public class MCDetectable extends MovieClip {

		public function MCDetectable() {
			TextField.prototype;
			if(stage){
				dispatchCreatedEvent()
			}else{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			}
		}

		private function onAddedToStage(event:Event):void {
			dispatchCreatedEvent()
		}
		protected function dispatchCreatedEvent():void {
			dispatchEvent(new MCDetectEvent(MCDetectEvent.CREATED, this, true, true));
		}
	}
}
