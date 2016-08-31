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
package pl.brun.lib.models {
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.adapters.LoaderAsAction;
	import pl.brun.lib.display.BitmapProviderEvent;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	[Event(name="newBitmap", type="pl.brun.lib.display.BitmapProviderEvent")]

	/**
	 * @author Marek Brun
	 */
	public class LoadedBitmap extends Base implements IBitmapProvider {

		private var _loader:LoaderAsAction;
		private var useCache:Boolean;

		public function LoadedBitmap(url:URLRequest, context:LoaderContext = null, useCache:Boolean = true, isAutoStartLoad:Boolean = true) {
			this.useCache = useCache
			if(useCache) {
				_loader = LoaderAsAction.createOrGetCachedByURL(url.url)
			} else {
				_loader = new LoaderAsAction()
				_loader.setup(url, context)
			}
			if(!gotBitmap()) {
				addEventSubscription(_loader, ActionEvent.RUNNING_FINISH, onLoader_RunningFinish);
				if(isAutoStartLoad) {
					_loader.start();
				}
			}
		}

		public function gotBitmap():Boolean {
			return _loader.isSuccess && _loader.getLoader().content && _loader.getLoader().content is Bitmap;
		}

		public function getBitmap():BitmapData {
			return Bitmap(_loader.getLoader().content).bitmapData;
		}

		override public function dispose():void {
			if(!useCache) {
				if(gotBitmap()) {
					getBitmap().dispose();
				}
				_loader.dispose();
			}
			_loader = null;
			super.dispose();
		}

		public function get loader():LoaderAsAction {
			return _loader;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onLoader_RunningFinish(event:ActionEvent):void {
			if(gotBitmap()) {
				dispatchEvent(new BitmapProviderEvent(BitmapProviderEvent.NEW_BITMAP, getBitmap()));
			}
		}
	}
}

internal class Private {
}