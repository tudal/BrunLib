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
package pl.brun.lib.display.displayObjects {
	import pl.brun.lib.display.BitmapProviderEvent;
	import pl.brun.lib.models.IBitmapProvider;

	import flash.display.Bitmap;
	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * created:2009-10-30 
	 * @author Marek Brun
	 */
	public class BitmapView extends Bitmap {

		private var model:IBitmapProvider;

		/*abstract*/
		protected function doAfterNewBitmap():void {
		}

		public function setModel(model:IBitmapProvider):void {
			if(this.model == model) {
				return;
			}
			unsetCurrentModel();
			this.model = model;			if(model.gotBitmap()) {
				bitmapData = model.getBitmap();
				doAfterNewBitmap();
				dispatchEvent(new Event(Event.CHANGE));
			}
			model.addEventListener(BitmapProviderEvent.NEW_BITMAP, onModel_NewBitmap, false, 0, true);
		}

		public function unsetCurrentModel():void {
			if(!model) { 
				return; 
			}
			model.removeEventListener(BitmapProviderEvent.NEW_BITMAP, onModel_NewBitmap);
			bitmapData = null;
			model = null;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onModel_NewBitmap(event:BitmapProviderEvent):void {
			var smo:Boolean = smoothing
			bitmapData = event.bitmap;
			smoothing = smo
			doAfterNewBitmap();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
