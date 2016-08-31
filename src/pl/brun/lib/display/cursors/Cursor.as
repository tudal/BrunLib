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
package pl.brun.lib.display.cursors {
	import pl.brun.lib.display.DisplayBase;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * 
	 * Check class:
	 * pl.brun.lib.test.display.button.view.cursorButtonViews.DraggingCursorButtonViewClassTest
	 * for tests
	 * 
	 * created: 2009-12-19
	 * @author Marek Brun
	 */
	public class Cursor extends DisplayBase {

		private var graphic:DisplayObject;
		private var _rank:uint;

		public function Cursor(graphic:DisplayObject, rank:uint) {
			super(new Sprite());
			container.addChild(graphic);
			this.graphic = graphic;
			this._rank = rank;
			container.mouseChildren = false;
			container.mouseEnabled = false;
		}

		public function get rank():uint {
			return _rank;
		}
	}
}
