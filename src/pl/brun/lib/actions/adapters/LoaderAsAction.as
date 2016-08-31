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
package pl.brun.lib.actions.adapters {
	import flash.errors.IOError;
	import pl.brun.lib.actions.Action;

	import flash.display.Loader;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	/**
	 * 
	 * Start:
	 *  - external - when you setup loading in this class by using "setup" method,
	 *  			 and then call "start" 
	 *  - internal - when you start passed loader instance with load method,
	 *  			 then action will be start automatically with OPEN event of loader
	 * Finish - internal
	 * 
	 * Running - loader is loading
	 * Idle - loading not started or already loaded
	 * 
	 * isSuccess==true - content load complete
	 * 
	 * Instance can be started again after loading finish - it will be start
	 * with immediately finish - without loading.
	 * 
	 * created:2009-10-29
	 * @author Marek Brun
	 */
	public class LoaderAsAction extends Action {

		private static var dictCachedURL_LoaderAsAction:Dictionary = new Dictionary();
		protected var loader:Loader;
		private var _isCompleted:Boolean;
		private var isOpen:Boolean;
		private var request:URLRequest;
		private var context:LoaderContext;
		private var isLoadStarted:Boolean;
		private var isAddToCache:Boolean;
		private var _isIOError:Boolean;
		public var throwIOError:Boolean;

		public function LoaderAsAction(loader:Loader = null, isAddToCache:Boolean = true) {
			this.loader = loader ? loader : new Loader();
			this.isAddToCache = isAddToCache;
			addEventSubscription(this.loader.contentLoaderInfo, Event.COMPLETE, onLoader_Complete, false, 0, true);
			addEventSubscription(this.loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, onLoader_IOError, false, 0, true);
			addEventSubscription(this.loader.contentLoaderInfo, Event.UNLOAD, onLoader_Unload, false, 0, true);			addEventSubscription(this.loader.contentLoaderInfo, Event.OPEN, onLoader_Open, false, 0, true);
			cache();
		}

		private function cache():void {
			if(loader.contentLoaderInfo.url && isAddToCache) {
				dictCachedURL_LoaderAsAction[loader.contentLoaderInfo.url] = this;
			}
		}

		public function setup(request:URLRequest, context:LoaderContext = null):void {
			this.request = request;
			this.context = context;
			cache();
		}

		override protected function doRunning():void {
			if(_isCompleted) {
				//it's been already loaded so we just skip this action
				isRunningFlag = false;
				return;
			}
			cache();
		}

		override protected function prepareToStart():void {
			if(isLoadStarted) {
				return;
			}
			if(!request) {
				throw IllegalOperationError("Action started without setup of loader - please use setup method fist.");
			}
			isLoadStarted = true;
			loader.load(request, context);
			readyToStart();
		}

		override protected function canBeStarted():Boolean {
			return _isCompleted || isOpen;
		}

		public function getLoader():Loader {
			return loader;
		}

		public static function createOrGetCachedByURL(url:String):LoaderAsAction {
			if(dictCachedURL_LoaderAsAction[url]) {
				return dictCachedURL_LoaderAsAction[url];
			}
			var loader:LoaderAsAction = new LoaderAsAction();
			loader.setup(new URLRequest(url));
			dictCachedURL_LoaderAsAction[url] = loader;
			return loader;
		}

		public function get isIOError():Boolean {
			return _isIOError;
		}

		override public function dispose():void {
			loader = null;
			super.dispose();
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onLoader_Complete(event:Event):void {
			_isCompleted = true;
			markAsSuccessAction();
			finish();
		}

		private function onLoader_IOError(event:IOErrorEvent):void {
			_isIOError = true;
			var msg:String
			if(request) {
				msg='WARNING: fail to load:' + request.url
			} else {				msg='WARNING: fail to load:' + loader.contentLoaderInfo.url
			}
			dbg.log(msg)
			if(throwIOError) throw new IOError(msg);
			_isCompleted = true;
			finish();
		}

		private function onLoader_Unload(event:Event):void {
			_isCompleted = true;
			finish();
		}

		private function onLoader_Open(event:Event):void {
			isOpen = true;
			start();
		}
		
		public function get isCompleted():Boolean {
			return _isCompleted;
		}
	}
}
