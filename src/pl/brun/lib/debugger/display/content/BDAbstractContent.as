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
package pl.brun.lib.debugger.display.content {
	import pl.brun.lib.debugger.model.content.IBDClearable;
	import pl.brun.lib.debugger.model.content.IBDContentProvider;
	import pl.brun.lib.debugger.model.content.IBDRefreshable;
	import pl.brun.lib.display.DisplayBase;

	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * created: 2009-12-20
	 * @author Marek Brun
	 */
	public class BDAbstractContent extends DisplayBase {
		public var name:String;
		protected var width:Number;
		protected var height:Number;
		private var _enabled:Boolean;
		private var _label:String;
		private var model:IBDContentProvider;
		private var clearItem:ContextMenuItem;
		private var refreshItem:ContextMenuItem;

		public function BDAbstractContent(label:String, model:IBDContentProvider) {
			name = label;
			_label = label;
			super(new Sprite());
			this.model = model;
			_enabled = false;

			try {
				container.contextMenu = new ContextMenu();
				if (container.contextMenu) container.contextMenu['hideBuiltInItems']();

				if (model is IBDClearable) {
					clearItem = new ContextMenuItem('clear');
					addEventSubscription(clearItem, ContextMenuEvent.MENU_ITEM_SELECT, onClearItem_MenuItemSelect);
					if (container.contextMenu) container.contextMenu['customItems'].unshift(clearItem);
				}

				if (model is IBDRefreshable) {
					refreshItem = new ContextMenuItem('refresh');
					addEventSubscription(refreshItem, ContextMenuEvent.MENU_ITEM_SELECT, onRefreshItem_MenuItemSelect);
					if (container.contextMenu) container.contextMenu['customItems'].unshift(refreshItem);
				}
			} catch(e:Error) {
			}
		}

		override public function dispose():void {
			model = null;
			clearItem = null;
			refreshItem = null;
			super.dispose();
		}

		/*abstract*/
		protected function enable():void {
		}

		/*abstract*/
		protected function disable():void {
		}

		/*abstract*/
		protected function refreshSize():void {
		}

		public function setSize(width:Number, height:Number):void {
			this.height = height;
			this.width = width;
			refreshSize();
		}

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(enabled:Boolean):void {
			_enabled = enabled;
			if (enabled) {
				enable();
				if (model is IBDRefreshable) {
					IBDRefreshable(model).refresh();
				}
			} else {
				disable();
			}
		}

		public function get label():String {
			return _label;
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onClearItem_MenuItemSelect(event:ContextMenuEvent):void {
			IBDClearable(model).clear();
		}

		private function onRefreshItem_MenuItemSelect(event:ContextMenuEvent):void {
			IBDRefreshable(model).refresh();
		}
	}
}
