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
	import debuggerAssets.BDBGWindowTextContentMC;

	import pl.brun.lib.controller.ScrollController;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.IBDTextContentProvider;
	import pl.brun.lib.display.ui.scroller.Scroller;
	import pl.brun.lib.models.ScrollableTextField;
	import pl.brun.lib.tools.CallOncePerFrame;

	import flash.events.Event;

	/**
	 * created: 2009-12-20
	 * @author Marek Brun
	 */
	public class BDTextContent extends BDAbstractContent {

		public var isScrollToDown:Boolean;
		protected var mc:BDBGWindowTextContentMC;
		private var model:IBDTextContentProvider;
		private var scrollController:ScrollController;
		private var scrollerUI:Scroller;
		private var tfScrollModel:ScrollableTextField;
		private var links:BDTextsManager;
		protected var isInit:Boolean;

		public function BDTextContent(label:String, model:IBDTextContentProvider, links:BDTextsManager) {
			super(label, model);
			this.links = links;
			this.model = model;
		}

		protected function init():void {
			if(isInit) {
				return;
			}
			isInit = true
			mc = new BDBGWindowTextContentMC();
			container.addChild(mc);
			
			links.registerTextFieldWithLinks(mc.tf);
			
			scrollerUI = new Scroller(mc.scroller);
			tfScrollModel = new ScrollableTextField(mc.tf);
			scrollController = new ScrollController(tfScrollModel, scrollerUI);
			
			draw();
			mc.tf.scrollV = 0;
		}

		protected function getText():String {
			return model.getText();
		}

		protected function draw():void {
			init()
			if(!CallOncePerFrame.call(draw)) {
				return;
			}
			var isScrolledToDown:Boolean = mc.tf.scrollV == mc.tf.maxScrollV;
			mc.tf.htmlText = getText();
			if(isScrollToDown && isScrolledToDown) { 
				mc.tf.scrollV = mc.tf.maxScrollV; 
			}
		}

		override protected function enable():void {
			addEventSubscription(model, Event.CHANGE, onModel_Change);
			draw();		}

		override protected function disable():void {
			removeEventSubscription(model, Event.CHANGE, onModel_Change);
		}

		override protected function refreshSize():void {
			scrollerUI.size = height;
			scrollerUI.container.x = width - scrollerUI.container.width;			mc.tf.height = height;
			mc.tf.width = width;
			tfScrollModel.afterChange();
		}

		override public function dispose():void {
			if(isInit) {
				scrollController.dispose()
				scrollController = null
				scrollerUI.dispose()				scrollerUI = null
				tfScrollModel.dispose()				tfScrollModel = null
				mc = null
			}
			links = null
			super.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onModel_Change(event:Event):void {
			draw();
		}
	}
}
