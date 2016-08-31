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
package pl.brun.lib.util {
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * created: 2009-12-05
	 * @author Marek Brun
	 */
	public class DisplayAlignUtil {

		static public function getYMargin(displayTop:DisplayObject, displayBottom:DisplayObject):Number {
			if(displayTop.parent != displayBottom.parent) {
				throw new ArgumentError('displayTop.parent != displayBottom.parent');
			}
			var topBox:Rectangle = displayTop.getBounds(displayTop.parent);
			var bottomBox:Rectangle = displayBottom.getBounds(displayBottom.parent);
			
			return bottomBox.y - topBox.bottom;
		}

		static public function alignMovedTopToBaseBottom(moved:DisplayObject, base:DisplayObject, marg:Number = 0):void {
			moved.y = 0;
			var baseBox:Rectangle = base.getBounds(base.parent);
			var movedBox:Rectangle = moved.getBounds(base.parent);
			moved.y = baseBox.bottom - movedBox.top + marg;
		}

		static public function alignMovedRightToBaseRight(moved:DisplayObject, base:DisplayObject):void {
			moved.x = 0;
			var baseBox:Rectangle = base.getBounds(base.parent);
			var movedBox:Rectangle = moved.getBounds(base.parent);
			moved.x = baseBox.right - movedBox.right;
		}

		static public function alignMovedLeftToBaseRight(moved:DisplayObject, base:DisplayObject):void {
			moved.x = 0;
			var baseBox:Rectangle = base.getBounds(base.parent);
			var movedBox:Rectangle = moved.getBounds(base.parent);
			moved.x = baseBox.right - movedBox.left;
		}

		static public function alignMovedRightToBaseLeft(moved:DisplayObject, base:DisplayObject):void {
			moved.x = 0;
			var baseBox:Rectangle = base.getBounds(base.parent);
			var movedBox:Rectangle = moved.getBounds(base.parent);
			moved.x = baseBox.left - movedBox.right;
		}
	}
}
