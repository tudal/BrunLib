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
package pl.brun.lib.models.easing {

	/**
	 * created: 2009-11-29
	 * @author Marek Brun
	 */
	public class Easing {

		public var isMirror:Boolean;
		public var isDouble:Boolean;

		public function Easing() {
		}

		/**
		 * @param input from 0 to 1
		 */
		public function getEasing(input:Number, isForceMirror:Boolean = false):Number {
			if(isDouble) {
				if(input < 0) {
					return 0;
				}else if(input < 0.5) {
					return ( 1 - precalculateEasing(1 - input * 2, isForceMirror) ) / 2;
				} else {
					return 0.5 + precalculateEasing((input - .5) * 2, isForceMirror) * .5;
				}
			}
			return precalculateEasing(input, isForceMirror);
		}

		private function precalculateEasing(input:Number, isForceMirror:Boolean = false):Number {
			if(isMirror || isForceMirror) {
				return 1 - calculateEasing(1 - input);
			}
			return calculateEasing(input);
		}

		protected function calculateEasing(input:Number):Number {
			return input;
		}
	}
}
