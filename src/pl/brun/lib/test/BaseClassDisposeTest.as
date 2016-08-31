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
	import fl.controls.Button;

	import pl.brun.lib.events.EventPlus;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class BaseClassDisposeTest extends TestBase {

		private var some:SomeClassToDispose;
		private var buttonDispose:Button;

		public function BaseClassDisposeTest() {
			some = new SomeClassToDispose();
			dbg.log('some:' + dbg.link(some));
			
			some.addEventListener(EventPlus.BEFORE_DISPOSED, onSome_BeforeDisposed);
			some.addEventListener(SomeClassToDisposeEvent.TICK, onSome_Tick);
			
			buttonDispose = new Button();
			buttonDispose.addEventListener(MouseEvent.CLICK, onButtonDispose_Click);
			buttonDispose.label = 'dispose "some"';
			
			holder.addChild(buttonDispose);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		protected function onSome_BeforeDisposed(event:Event):void {
			dbg.log('onSome_BeforeDisposed()');
			some = null;
			buttonDispose.enabled = false;
		}

		private function onSome_Tick(event:SomeClassToDisposeEvent):void {
			dbg.log('onSome_Tick()');
		}

		private function onButtonDispose_Click(event:MouseEvent):void {
			dbg.log('onButtonDispose_Click()');
			some.dispose();
		}
	}
}
