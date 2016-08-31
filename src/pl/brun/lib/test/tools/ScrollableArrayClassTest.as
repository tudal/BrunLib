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
package pl.brun.lib.test.tools {
	import fl.events.ScrollEvent;

	import pl.brun.lib.models.ScrollableArray;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.tools.FrameDelayCall;
	import pl.brun.lib.util.ArrayUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * created:2009-11-22
	 * @author Marek Brun
	 */
	public class ScrollableArrayClassTest extends TestBase {

		private var mc:ScrollableArrayClassTestMC;
		private var scrolledArray:ScrollableArray;
		private var textFields:Array /*of TextField*/= [];
		private var data:Array;

		public function ScrollableArrayClassTest() {
			mc = new ScrollableArrayClassTestMC();
			holder.addChild(mc);
			
			mc.scrollBar.scrollTarget = null;
			mc.scrollBar.maxScrollPosition = 1;
			mc.scrollBar.pageScrollSize = 1;
			mc.scrollBar.addEventListener(ScrollEvent.SCROLL, onScrollBar_Scroll);
			
			
			var countTextFields:uint = 0;
			while(mc['tf' + countTextFields]) {
				textFields.push(mc['tf' + countTextFields]);
				countTextFields++;
			}
			
			data = 'one,two,three,four,fove,six,seven,eight,nine,ten'.split(',');
			data = data.concat(data, data); //length: 30
			scrolledArray = new ScrollableArray(null, textFields.length);
			scrolledArray.setNewArray(data);
			scrolledArray.addEventListener(Event.CHANGE, onScrolledArray_Change);
						mc.btnRemove.addEventListener(MouseEvent.CLICK, onBtnRemove_Click);
			mc.btnAdd.addEventListener(MouseEvent.CLICK, onBtnAdd_Click);
			
			draw();
		}

		private function draw():void {
			mc.scrollBar.pageSize = scrolledArray.getVisibleToTotal();
			mc.scrollBar.scrollPosition = scrolledArray.getIndexScroll();
			var currentArray:Array = scrolledArray.getCurrentArray();
			var i:uint;
			var tf:TextField;
			for(i = 0;i < textFields.length;i++) {
				tf = textFields[i];
				if(currentArray[i]) {
					tf.text = scrolledArray.getIndexByScrollIndex(i) + ': value:' + currentArray[i];
				} else {
					tf.text = '';
				}
			}
			
			//because of some UIScrollBar bug, there must be 2 frames delay
			//before we can set scrollPosition
			FrameDelayCall.addCall(updateScroller, 2);
		}

		private function updateScroller():void {
			//from some reason, if scrollPosition is 0 or 1 then pageSize dosent update  
			mc.scrollBar.scrollPosition = scrolledArray.getIndexScroll();
			mc.scrollBar.pageSize = scrolledArray.getVisibleToTotal();
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onScrollBar_Scroll(event:ScrollEvent):void {
			scrolledArray.setScroll(mc.scrollBar.scrollPosition);
		}

		private function onScrolledArray_Change(event:Event):void {
			draw();
		}

		private function onBtnRemove_Click(event:MouseEvent):void {
			data.splice(ArrayUtils.getRandomIndex(data), 1);
			scrolledArray.update();
			draw();		}

		private function onBtnAdd_Click(event:MouseEvent):void {
			data.push(String(int(Math.random() * 10000)));
			scrolledArray.update();
			draw();
		}
	}
}
