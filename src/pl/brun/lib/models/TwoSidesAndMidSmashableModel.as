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

	/**
	 * @author Marek Brun
	 */
	public class TwoSidesAndMidSmashableModel extends Base {

		public var side0Length:Number = 0;
		public var side1Length:Number = 0;
		public var lengtH:Number = 0;

		// side0 - mid - side1
		public function TwoSidesAndMidSmashableModel() {
		}

		public function get isSmashed():Boolean {
			return side0Length + side1Length > lengtH;
		}

		/**
		 * @return from 0 to 1
		 */
		public function get smash():Number {
			return lengtH / (side0Length + side1Length);
		}

		public function getSide0Length():Number {
			if(isSmashed) {
				return side0Length * smash;
			}
			return side0Length;
		}

		public function getSide1Length():Number {
			if(isSmashed) {
				return side1Length * smash;
			}
			return side1Length;
		}

		public function getMidIniPos():Number {
			return getSide0Length();
		}

		public function getMidLength():Number {
			if(isSmashed) {
				return 0;
			}
			return lengtH - getSide0Length() - getSide1Length();
		}

		public function getSide1IniPos():Number {
			return getMidIniPos() + getMidLength();
		}

		public function getSidesLength():Number {
			return getSide0Length() + getSide1Length();
		}
	}
}
