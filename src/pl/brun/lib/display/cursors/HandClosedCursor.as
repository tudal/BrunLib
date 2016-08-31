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
	import pl.brunlibassets.Cursor_closedhand_pngMC;

	import flash.display.MovieClip;

	/**
	 * created: 2009-12-19
	 * @author Marek Brun
	 */
	public class HandClosedCursor extends Cursor {

		public function HandClosedCursor(rank:uint = 1) {
			var graphic:MovieClip = new Cursor_closedhand_pngMC();
			super(graphic, rank);
		}
	}
}
