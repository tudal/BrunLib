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
	 * @author Marek Brun
	 */
	public class BDLoggerModel extends Base implements IBDTextContentProvider, IBDClearable {

		public var maxLines:uint = 400;		private var lastTitle:String;
		private var lastLogText:String = '';
		private var countRepeats:uint = 0;
		private var texts:Array = [];

		public function BDLoggerModel() {
		}

		public function addLog(logText:String):void {
			lastTitle = null;
			addLog2(logText);
		}

		public function getText():String {
			if(texts.length) {
				return texts.join('\n') + '\n' + getLastLog();
			}
			return getLastLog();
		}

		public function addLogWithTitle(title:String, logText:String):void {
			if(lastTitle != title) {
				lastTitle = title;
				addLog2(title);
			}
			addLog2('   ' + logText);
		}

		public function clear():void {
			countRepeats = 0;
			texts = [];
			lastLogText = '';
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function addLog2(logText:String):void {
			if(lastLogText == logText) {
				countRepeats++;
				dispatchEvent(new Event(Event.CHANGE));
				return;
			}
			
			if(lastLogText) {
				texts.push(getLastLog());
				while(texts.length > maxLines) {
					texts.shift();
				}
			}
			countRepeats = 0;
			lastLogText = logText;
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function getLastLog():String {
			if(countRepeats > 0) {
				return lastLogText + ' <b>*' + (countRepeats + 1) + '</b>';
			} else {
				return lastLogText;
			}
		}
	}
}
