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
package pl.brun.lib.display.button.views.cursorButtonViews {
	import flash.events.MouseEvent;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.display.button.ButtonModel;
	import pl.brun.lib.display.button.views.AbstractButtonView;
	import pl.brun.lib.display.cursors.CursorsManager;
	import pl.brun.lib.display.cursors.HandClosedCursor;
	import pl.brun.lib.display.cursors.HandOpenCursor;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.models.IDisplayObjectOperator;

	import flash.display.DisplayObject;

	/**
	 * created: 2009-12-19
	 * @author Marek Brun
	 */
	public class DraggingCursorButtonView extends AbstractButtonView implements IDisplayObjectOperator {

		private static var handOpenCursor:HandOpenCursor;
		private static var handClosedCursor:HandClosedCursor;

		public function DraggingCursorButtonView() {
			if(!handOpenCursor) {
				handOpenCursor = new HandOpenCursor();
			}
			if(!handClosedCursor) {
				handClosedCursor = new HandClosedCursor();
			}
		}

		override public function setModel(model:ButtonModel):void {
			model.addEventListener(EventPlus.BEFORE_DISPOSED, onModel_Dispose);
			super.setModel(model);
		}

		override protected function doRollOver():void {
			CursorsManager.show(this, handOpenCursor);
		}

		override protected function doPress():void {
			CursorsManager.show(this, handClosedCursor);
			StageProvider.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseUp)
		}

		private function onMouseUp(event:MouseEvent):void {
			CursorsManager.hide(this, handClosedCursor);
		}

		override protected function doRollOut():void {
			CursorsManager.hide(this, handOpenCursor);
		}

		public function get display():DisplayObject {
			if(model is IDisplayObjectOperator) {
				return IDisplayObjectOperator(model).display;
			}
			return null;
		}

		override public function dispose():void {
			CursorsManager.hide(this, handOpenCursor);
			super.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onModel_Dispose(event:EventPlus):void {
			CursorsManager.removeAllCursorsByRequester(this);
		}
	}
}
