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
package pl.brun.lib.debugger.display {
	import pl.brun.lib.debugger.display.content.BDAbstractContent;
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.display.button.ButtonModel;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * created: 2009-12-20
	 * @author Marek Brun
	 */
	public class BDWindowContent extends DisplayBase {

		private var tfTop:TextField;
		private var tfTabs:TextField;
		private var btnHistFront:ButtonModel;
		private var btnHistBack:ButtonModel;
		private var mask:Sprite;
		private var currentContentHolder:Sprite;
		private var currentContent:BDAbstractContent;
		private var width:Number = 1;
		private var height:Number = 1;
		private var provider:IBDWindowContentProvider;
		private var contents:Array/*of AbstractBDBGWindowContent*/;
		private var whiteBG:Sprite;

		public function BDWindowContent(provider:IBDWindowContentProvider, tfTop:TextField, tfTabs:TextField) {
			super();
			this.provider = provider;
			this.tfTabs = tfTabs;
			this.tfTop = tfTop;
			this.btnHistBack = btnHistBack;
			this.btnHistFront = btnHistFront;
			this.contents = provider.getWindowContents();
			
			whiteBG = DisplayUtils.createRect(0xFFFFFF);			mask = DisplayUtils.createRect(0xFF0000);
			currentContentHolder = new Sprite();
			container.addChild(mask);			container.addChild(currentContentHolder);			currentContentHolder.mask = mask;
			
			container.addChildAt(whiteBG, 0);
			
			setContent(contents[0]);
			enable();
		}

		private function drawTabs():void {
			var tabs:Array /*of String*/= [];
			var i:uint;
			var content:BDAbstractContent;
			for(i = 0;i < contents.length;i++) {
				content = contents[i];
				if(content == currentContent) {
					tabs.push('<b>' + content.label + '</b>');
				} else {
					tabs.push('<A HREF="event:' + i + '">' + content.label + '</A>');
				}
			}
			
			tfTabs.htmlText = tabs.join(' | ');
		}

		public function enable():void {
			currentContent.enabled = true;
			provider.setIsWindowSelected(true);
			
			tfTop.text = provider.getWindowTitle();
			tfTabs.addEventListener(TextEvent.LINK, onTfTabs_Link);
			drawTabs();
		}

		public function disable():void {
			currentContent.enabled = false;
			provider.setIsWindowSelected(false);
			tfTabs.removeEventListener(TextEvent.LINK, onTfTabs_Link);
		}

		private function setContent(content:BDAbstractContent):void {
			if(currentContent == content) {
				return;
			}
			if(currentContent) {
				currentContent.enabled = false;
				currentContentHolder.removeChild(currentContent.container);
			}			currentContent = content;
			currentContent.enabled = true;
			currentContentHolder.addChild(currentContent.container);
			
			currentContent.setSize(width, height);
			
			drawTabs();
		}

		public function setSize(width:Number, height:Number):void {
			this.height = height;
			this.width = width;
			mask.width = width;			mask.height = height;
			whiteBG.width = width;			whiteBG.height = height;
			if(currentContent) {
				currentContent.setSize(width, height);
			}
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onTfTabs_Link(event:TextEvent):void {
			setContent(contents[parseInt(event.text)]);
		}
	}
}
