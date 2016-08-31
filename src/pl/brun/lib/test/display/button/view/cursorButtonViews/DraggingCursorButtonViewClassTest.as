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
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;

	/**
	 * created: 2009-12-19
	 * @author Marek Brun
	 */
	public class DraggingCursorButtonViewClassTest extends TestBase {

		private var mc:DraggingCursorButtonViewClassTestMC;
		private var draggedRects:Array /*of DraggedRect*/ = [];
		private var dragRectMCs:Array /*of MovieClip*/;

		public function DraggingCursorButtonViewClassTest() {
			mc = new DraggingCursorButtonViewClassTestMC();
			holder.addChild(mc);
			
			dragRectMCs = [mc.drag0, mc.drag1, mc.drag2];
			
			var i:uint;
			var draggedRectMC:MovieClip;
			var draggedRect:DraggedRect;
			for(i = 0;i < dragRectMCs.length;i++) {
				draggedRectMC = dragRectMCs[i];
				draggedRect = new DraggedRect(draggedRectMC, mc.badDragZone.getBounds(mc), mc.goodDragZone.getBounds(mc));
				draggedRects.push(draggedRect);
			}
			
			addTestKey('R'.charCodeAt(0), removeDragRectsFromStage, null, 'removeDragRectsFromStage();');			addTestKey('A'.charCodeAt(0), addDragRectsFromStage, null, 'addDragRectsFromStage();');			addTestKey('D'.charCodeAt(0), disposeDragRects, null, 'disposeDragRects();');
		}

		private function disposeDragRects():void {
			var i:uint;
			var draggedRect:DraggedRect;
			for(i = 0;i < draggedRects.length;i++) {
				draggedRect = draggedRects[i];
				draggedRect.dispose();
			}
			draggedRects = null;
		}

		private function removeDragRectsFromStage():void {
			DisplayUtils.removeChildren(dragRectMCs);
		}

		private function addDragRectsFromStage():void {
			DisplayUtils.addChildren(dragRectMCs, mc);
		}
	}
}
