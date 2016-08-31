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
	public class Bezier3Easing extends Easing {

		/** from -2 to 2 */
		public var one:Number = 0;
		/** from -2 to 2 */
		public var two:Number = 0;
		/** from -2 to 2 */
		public var three:Number = 0;

		override protected function calculateEasing(input:Number):Number {
			return 1 - bezier(input, 0, one, two, three, 1);
		}

		private function bezier(cou:Number, n1:Number, n2:Number, n3:Number, n4:Number, n5:Number):Number {
			return n1 * bezier1(cou) + n2 * bezier2(cou) + n3 * bezier3(cou) + n4 * bezier4(cou) + n5 * bezier5(cou);
		}

		private function bezier1(t:Number):Number { 
			return t * t * t * t; 
		}

		private function bezier2(t:Number):Number { 
			return 4 * t * t * t * (1 - t); 
		}

		private function bezier3(t:Number):Number { 
			return 6 * t * t * (1 - t) * (1 - t); 
		}

		private function bezier4(t:Number):Number { 
			return 4 * t * (t -= 1) * t * t; 
		}

		private function bezier5(t:Number):Number { 
			t = 1 - t;
			return t * t * t * t; 
		}
	}
}
