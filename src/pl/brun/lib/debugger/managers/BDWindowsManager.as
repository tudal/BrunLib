package pl.brun.lib.debugger.managers {
	import pl.brun.lib.debugger.display.BDWindow;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.events.SelectEvent;
	import pl.brun.lib.util.ArrayUtils;
	import pl.brun.lib.util.DictionaryUtils;

	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDWindowsManager extends DisplayBase {

		private var dictProvider_Window:Dictionary = new Dictionary(true);
		private var links:BDTextsManager;		private var windows:Array /*of BDWindow*/= [];
		private var currentSelectedWindow:BDWindow;

		public function BDWindowsManager(links:BDTextsManager) {
			this.links = links;
		}

		public function getOveredWindow():BDWindow {
			var i:uint;
			var window:BDWindow;
			for(i = 0;i < windows.length;i++) {
				window = windows[i];
				if(window.isOvered) {
					return window;
				}
			}
			return null;
		}

		private function deselectCurrentWindow():void {
			if(currentSelectedWindow) {
				currentSelectedWindow.isSelected = false;
			}
			root.removeEventListener(MouseEvent.MOUSE_DOWN, onStage_MouseDown_WhileSelected);
		}

		public function selectWindow(window:BDWindow):void {
			deselectCurrentWindow();
			currentSelectedWindow = window;
			window.isSelected = true;
			container.addChild(window.container);
			root.addEventListener(MouseEvent.MOUSE_DOWN, onStage_MouseDown_WhileSelected, false, 0, true);
		}

		public function getWindow(provider:IBDWindowContentProvider):BDWindow {
			if(!dictProvider_Window[provider]) {
				var window:BDWindow = new BDWindow(provider);
				addEventSubscription(window, SelectEvent.SELECT_REQUEST, onWindow_SelectRequest);				addEventSubscription(window, EventPlus.BEFORE_DISPOSED, onWindow_Dispose);
				window.container.x = container.mouseX;				window.container.y = container.mouseY;
				dictProvider_Window[provider] = window;
				windows.push(window);
				container.addChild(window.container);
				provider.addDisposeChild(window);
			}
			return dictProvider_Window[provider];
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onWindow_SelectRequest(event:SelectEvent):void {
			selectWindow(BDWindow(event.target));
		}

		private function onWindow_Dispose(event:EventPlus):void {
			var window:BDWindow = BDWindow(event.target);
			if(window == currentSelectedWindow) {
				currentSelectedWindow = null;
				deselectCurrentWindow();
			}
			ArrayUtils.remove(windows, window);
			DictionaryUtils.deleteByValue(dictProvider_Window, window);
		}

		private function onStage_MouseDown_WhileSelected(event:MouseEvent):void {
			if(!currentSelectedWindow.isOvered) {
				deselectCurrentWindow();
			}
		}
	}
}
