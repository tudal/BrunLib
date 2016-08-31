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
package pl.brun.lib.test.debugger.display {
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDTextModel;
	import pl.brun.lib.events.SelectEvent;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.test.TestBase;

	/**
	 * created: 2009-12-16
	 * @author Marek Brun
	 */
	public class BDWindowClassTest extends TestBase implements IBDWindowContentProvider {

		private var window:BDWindow;
		private var text:BDTextModel;
		private var textView:BDTextContent;
		private var links:BDTextsManager;

		public function BDWindowClassTest() {
			if(Object(this).constructor == BDWindowClassTest) {
				createTestWindow();
			}
		}

		private function createTestWindow():void {
			var weaks:WeakReferences = new WeakReferences();
			links = new BDTextsManager(weaks);
			
			text = new BDTextModel();
			textView = new BDTextContent('test', text, links);
			
			createWindow(this);
		}

		protected function createWindow(provider:IBDWindowContentProvider):void {
			window = new BDWindow(provider);
			window.addEventListener(SelectEvent.SELECT_REQUEST, onWindow_SelectRequest);
			holder.addChild(window.container);
			
			addTestKey('M'.charCodeAt(0), switchIsMinimalized, null, 'switchIsMinimalized();');
			addTestKey('E'.charCodeAt(0), deselectWindow, null, 'deselectWindow();');
		}

		private function switchIsMinimalized():void {
			window.isMinimalized = !window.isMinimalized;
		}

		private function deselectWindow():void {
			window.isSelected = false;
		}

		public function getWindowTitle():String {
			return 'title';
		}

		public function getWindowContents():Array {
			return [textView];
		}

		public function getServicedObject():Object {
			return this;
		}
		
		public function addDisposeChild(disposeChild:IDisposable):*
		{
		}
		
		public function addDisposeChildren(disposeChilds:Array):void
		{
		}
		
		public function dispose():void
		{
		}
		
		public function get isDisposed():Boolean {
			return false;
		}

		public function setIsWindowSelected(isSelected:Boolean):void {
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onWindow_SelectRequest(event:SelectEvent):void {
			window.isSelected = true;
		}
	}
}
