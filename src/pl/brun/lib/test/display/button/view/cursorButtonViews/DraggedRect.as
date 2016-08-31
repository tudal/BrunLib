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
package pl.brun.lib.test.display.button.view.cursorButtonViews {
	import pl.brun.lib.display.button.ButtonEvent;
	import pl.brun.lib.display.button.SpriteButton;
	import pl.brun.lib.display.button.views.cursorButtonViews.DraggingCursorButtonView;
	import pl.brun.lib.display.cursors.Cursor;
	import pl.brun.lib.display.cursors.CursorsManager;

	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * created: 2009-12-19
	 * @author Marek Brun
	 */
	internal class DraggedRect extends SpriteButton {

		private var badZone:Rectangle;
		private var goodZone:Rectangle;
		private var cursorBad:Cursor;
		private var cursorGood:Cursor;

		public function DraggedRect(mc:MovieClip, badZone:Rectangle, goodZone:Rectangle) {
			this.goodZone = goodZone;
			this.badZone = badZone;
			super(mc);
			
			addView(new DraggingCursorButtonView());
			
			cursorBad = new Cursor(new CursorBadMC(), 3);			cursorGood = new Cursor(new CursorGoodMC(), 3);
			
			addEventListener(ButtonEvent.DRAG_MOVE, onThis_DragMove);
		}

		private function refreshGoodBadCursor():void {
			if(badZone.containsRect(display.getBounds(display.parent))) {
				if(goodZone.containsRect(display.getBounds(display.parent))) {
					//good zone
					CursorsManager.show(this, cursorGood);
					CursorsManager.hide(this, cursorBad);
				} else {
					//bad zone
					CursorsManager.show(this, cursorBad);
					CursorsManager.hide(this, cursorGood);
				}
			} else {
				//no zone
				CursorsManager.hide(this, cursorBad);
				CursorsManager.hide(this, cursorGood);
			}
		}

		override protected function doPress():void {
			//setting mc to top layer
			display.parent.addChild(display);
			refreshGoodBadCursor();
			super.doPress();
		}

		override protected function doRelease():void {
			CursorsManager.removeAllCursorsByRequester(this);
			super.doRelease();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onThis_DragMove(event:ButtonEvent):void {
			display.x = pressX + moveX;			display.y = pressY + moveY;
			refreshGoodBadCursor();
		}
	}
}
