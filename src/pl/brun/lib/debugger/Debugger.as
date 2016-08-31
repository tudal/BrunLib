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
package pl.brun.lib.debugger {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.creation.BDArrayDebugServiceCreation;
	import pl.brun.lib.debugger.creation.BDBigStringServiceCreation;
	import pl.brun.lib.debugger.creation.BDComplexDebugServiceCreation;
	import pl.brun.lib.debugger.creation.BDDisplayDebugServiceCreation;
	import pl.brun.lib.debugger.creation.BDObjectDebugServiceCreation;
	import pl.brun.lib.debugger.creation.BDVectorDebugServiceCreation;
	import pl.brun.lib.debugger.creation.BDXMLDebugServiceCreation;
	import pl.brun.lib.debugger.creation.IBDDebugServiceCreation;
	import pl.brun.lib.debugger.creation.IBDObjectLoggingProvider;
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.FPSMeterView;
	import pl.brun.lib.debugger.managers.BDDisplayHighlightManager;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.managers.BDWindowsManager;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.debugger.model.services.BDObjectLogging;
	import pl.brun.lib.debugger.windows.BDMainWindow;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.service.KeyboardService;
	import pl.brun.lib.tools.CompilationDate;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * created: 2009-12-15
	 * @author Marek Brun
	 */
	public class Debugger extends Base {
		private var _bordersHolder:Sprite;
		private var weaks:WeakReferences;
		private var _links:BDTextsManager;
		private var highligths:BDDisplayHighlightManager;
		private var dictObject_Creation:Dictionary = new Dictionary(true);
		private static var instance:Debugger;
		private var holder:Sprite;
		private var windowsManager:BDWindowsManager;
		private var mainWindowsHolder:Sprite;
		public var mainLogger:BDMainWindow;
		private var fps:FPSMeterView;

		// public var mainVauesLogger:BDMainVauesLogger;
		public function Debugger(holder:Sprite) {
			this.holder = holder;

			isDebuggerEnabled = true

			DebugServiceProxy.debugger = this;

			_bordersHolder = new Sprite();
			weaks = new WeakReferences();
			_links = new BDTextsManager(weaks);
			highligths = new BDDisplayHighlightManager();

			holder.addChild(highligths.container);

			mainWindowsHolder = new Sprite();
			holder.addChild(mainWindowsHolder);

			windowsManager = new BDWindowsManager(_links);
			holder.addChild(windowsManager.container);

			mainLogger = new BDMainWindow(_links);
			mainWindowsHolder.addChild(mainLogger.container);
			mainLogger.enableCookie('mainLogger');
			mainLogger.setSize(mainLogger.getWidth(), 150)

			fps = new FPSMeterView()
			fps.container.mouseChildren = false
			holder.addChild(fps.d)
			fps.d.x = 100

			// mainLogger
			_links.addEventListener(BDLinkEvent.LINK_CALL, onLinks_LinkCall);
			try {
				mainLogger.log(CompilationDate.ago(StageProvider.getStage().loaderInfo))
			} catch(e:Error) {
			}

			setTimeout(drawInfo, 1000);
		}

		public function sppedTestStart(id:String):void {
			mainLogger.sppedTestStart(id)
		}

		public function sppedTestStop(id:String):void {
			mainLogger.sppedTestStop(id)
		}

		public function get logv():BDValuesLoggerModel {
			return mainLogger.logv;
		}

		public function getCreation(obj:Object):IBDDebugServiceCreation {
			if (!dictObject_Creation[obj]) {
				var creaton:IBDDebugServiceCreation;
				if (obj is DisplayObject) {
					creaton = new BDDisplayDebugServiceCreation(DisplayObject(obj), _links, highligths);
				} else if (obj is Array) {
					creaton = new BDArrayDebugServiceCreation(obj as Array, _links);
				} else if (obj is Vector.<*>) {
					creaton = new BDVectorDebugServiceCreation(obj, _links);
				} else if (obj is XML) {
					creaton = new BDXMLDebugServiceCreation(XML(obj), _links);
				} else if (obj is String) {
					return new BDBigStringServiceCreation(String(obj), _links);
				} else if (obj is Object && Object(obj).constructor == Object) {
					creaton = new BDObjectDebugServiceCreation(obj, _links);
				} else {
					creaton = new BDComplexDebugServiceCreation(obj, _links, mainLogger);
				}
				dictObject_Creation[obj] = creaton;
			}
			return dictObject_Creation[obj];
		}

		public function getLogging(obj:Object):BDObjectLogging {
			var creation:IBDDebugServiceCreation = getCreation(obj)
			if (creation is IBDObjectLoggingProvider) {
				return IBDObjectLoggingProvider(getCreation(obj)).logging;
			}
			return null;
		}

		public function getWindow(obj:Object):BDWindow {
			var creation:IBDDebugServiceCreation = getCreation(obj);
			var window:BDWindow = windowsManager.getWindow(creation.windowContentProvider);
			return window;
		}

		public function showWindow(obj:Object):void {
			var creation:IBDDebugServiceCreation = getCreation(obj);
			windowsManager.selectWindow(windowsManager.getWindow(creation.windowContentProvider));
		}

		private function showInCurrentWindow(obj:Object):void {
			if (!obj) {
				mainLogger.log('no object');
				return;
			}
			var window:BDWindow = windowsManager.getOveredWindow();
			if (KeyboardService.isCtrlDown()) {
				windowsManager.selectWindow(windowsManager.getWindow(getCreation(obj).windowContentProvider));
			} else if (window) {
				var creation:IBDDebugServiceCreation = getCreation(obj);
				window.setProvider(creation.windowContentProvider);
			} else {
				showWindow(obj);
			}
		}

		public function get bordersHolder():Sprite {
			return _bordersHolder;
		}

		public static function init(holder:Sprite = null):void {
			if (!instance) {
				if (!holder) {
					holder = new Sprite();
					DisplayObjectContainer(RootProvider.getRoot()).addChild(holder);
				}
				instance = new Debugger(holder);
			}
		}

		public function get links():BDTextsManager {
			return _links;
		}

		private function drawInfo():void {
			var tfInfo:TextField = new TextField();
			holder.addChild(tfInfo);
			tfInfo.autoSize = TextFieldAutoSize.LEFT;
			tfInfo.background = true;
			/*var date:Date = CompilationDate.read()
			tfInfo.text = 'created at '+date.getFullYear()+'-'+(date.getMonth()+1)+'-'+date.getDate()+'  '+date.getHours()+':'+date.getMinutes()
			var dateNow:Date = new Date()
			var diff:Number = dateNow.getTime()-date.getTime()
			if(diff>1000*60*60){
			tfInfo.appendText('\n '+int(diff/(1000*60*60))+' hours ago')
			}else{
			tfInfo.appendText('\n '+int(diff/(1000*60))+' minutes ago')
			}*/
			tfInfo.text = "Debugger enabled"
			try {
				tfInfo.x = StageProvider.getStage().stageWidth / 2 - tfInfo.width / 2;
			} catch(e:Error) {
				tfInfo.x = 10
			}
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onLinks_LinkCall(event:BDLinkEvent):void {
			switch(event.link.type) {
				case BDLinkVO.TYPE_EXE:
					var func:Function = event.link.value;
					mainLogger.log('return value:' + links.createLink(func(), true));
					break;
				case BDLinkVO.TYPE_LONG_STRING:
					showInCurrentWindow(event.link.value);
					break;
				case BDLinkVO.TYPE_OBJECT:
					showInCurrentWindow(event.link.value);
					break;
			}
		}

		public function clear():void {
			mainLogger.cookie.reset()
		}
	}
}
