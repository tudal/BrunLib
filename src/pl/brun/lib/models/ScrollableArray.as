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
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.util.ArrayUtils;

	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]

	[Event(name="positionChanged", type="pl.brun.lib.events.PositionEvent")]

	/**
	 * created:2009-11-22
	 * @author Marek Brun
	 */
	public class ScrollableArray extends Base implements IScrollable {

		public function get event_ScrollChanged():String { 
			return 'ScrollChanged'; 
		}

		private var scrollScope:Number;
		private var arr:Array;
		private var scroll:Number;

		public function ScrollableArray(arr:Array = null, scrollScope:Number = 4) {
			this.arr = arr == null ? [] : arr.concat();
			this.scrollScope = scrollScope;
			scroll = 0;
		}

		public function update():void {
			setScroll(getIndexScroll());
		}

		public function setScrollScope(newScrollScope:Number):void {
			if(scrollScope == Math.round(newScrollScope)) { 
				return; 
			}
			scrollScope = Math.max(1, Math.min(Infinity, Math.round(newScrollScope)));
			scroll = Math.max(0, Math.min(scroll, getMaxScroll()));
			if(scroll < 0) { 
				scroll = 0; 
			}
			dispatchChange();
		}

		public function setNewArray(arr:Array):void {
			this.arr = arr;
			var orgScrollScope:Number = scrollScope;
			scrollScope = NaN;
			setScrollScope(orgScrollScope);
			dispatchChange();
		}

		public function getIndexScroll():Number {
			var maxScroll:Number = getMaxScroll();
			if(maxScroll > 0 && scroll > 0) {
				return scroll / maxScroll;
			} else {
				return 0;
			}
		}

		public function getScrollUnits():uint {
			return Math.round(getIndexScroll() * getMaxScroll());
		}

		public function setScroll(scroll:Number):void {
			if(isNaN(scroll)) {
				throw new ArgumentError('New scroll can\'t be NaN');
			}
			
			this.scroll = Math.max(0, Math.min(getMaxScroll(), Math.round(scroll * getMaxScroll())));
			
			dispatchChange();
		}

		private function dispatchChange():void {
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, getScroll()));
		}

		public function getScroll():Number {
			return scroll / getMaxScroll();
		}

		public function getLinesScroll():uint {
			return scroll;
		}

		public function setScrollByUnit(scrollUnits:uint):void {
			setScroll(scrollUnits / getMaxScroll());
		}

		public function setScrollByOneUnit(isUp:Boolean):void {
			if(!isUp && getScrollUnits() - 1 < 0) { 
				return; 
			}
			setScrollByUnit(isUp ? getScrollUnits() + 1 : getScrollUnits() - 1);
		}

		public function getCurrentArray():Array {
			if(arr.length < scrollScope) { 
				return arr.concat(); 
			}
			var currArr:Array = [];
			var scrollEnd:Number = scroll + scrollScope;
			for(var i:uint = scroll;i < scrollEnd;i++) {
				currArr.push(arr[i]);
			}
			return currArr;
		}

		public function getScrollScope():Number {
			return scrollScope;
		}

		public function getMaxScroll():Number {
			return arr.length - scrollScope;
		}

		public function geScrollArrayElementByScrollIndex(index:Number):Object {
			return arr[scroll + index];
		}

		public function getBaseNumberByListNumber(index:Number):Number {
			return scroll + index;
		}

		public function push(value:*):void {
			arr.push(value);
			dispatchChange();
		}

		public function remove(value:*):Boolean {
			if(ArrayUtils.remove(arr, value)) {
				if(scroll + scrollScope >= arr.length) {
					scroll = Math.max(0, arr.length - scrollScope - 1);
				}
				dispatchChange();
				return true;
			}
			return false;
		}

		public function getIndexByScrollIndex(scrollIndex:Number):Number { 
			return scroll + scrollIndex; 
		}

		public function getArrayElementByScrollArrayIndex(scrollIndex:Number):Object {
			return arr[scroll + scrollIndex];
		}

		public function getLength():Number { 
			return arr.length;
		}

		public function getArrayCopy():Array { 
			return arr.concat(); 
		}

		public function getVisibleToTotal():Number {
			return scrollScope / arr.length;
		}

		public function getVisibleArea():Number {
			return scrollScope;
		}

		public function getTotalArea():Number {
			return getLength();
		}

		override public function dispose():void {
			arr = null;
			super.dispose();
		}
	}
}
