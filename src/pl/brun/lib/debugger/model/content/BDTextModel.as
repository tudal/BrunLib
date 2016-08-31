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
package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;

	import flash.events.Event;

	/**
	 * Events:
	 *  - Event.CHANGE
	 * 
	 * @author Marek Brun
	 */
	public class BDTextModel extends Base implements IBDTextContentProvider, IBDClearable {

		protected var text:String = '';

		public function BDTextModel() {
		}

		public function setText(text:String):void {
			this.text = text;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getText():String {
			return text;
		}

		public function clear():void {
			text = '';
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
