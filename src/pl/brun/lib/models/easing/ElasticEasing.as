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
	 * created: 2009-11-30
	 * @author Marek Brun
	 */
	public class ElasticEasing extends Easing {

		/** from 1 to 40*/
		public var humps:Number = 8;
		/** from 0 to 5*/
		public var dynamic_:Number = 1.8;
		/** from 0 to 3*/
		public var power:Number = 1;
		/** from 0 to 3*/
		public var friction:Number = 1;

		override protected function calculateEasing(input:Number):Number {
			return elastic(input, humps, dynamic_, power, friction);
		}

		public static function elastic(n:Number, humps:Number, dynamic_:Number, power:Number, friction:Number):Number {
			var dzi01:Number = 1 / (int(humps) + .5);
			var gln:Number = Math.pow(n, dynamic_) / dzi01;
			var glp:Number = gln - int(gln);
			var gln2:Number = gln * 2;
			var part4:Number = (gln2 + 6) % 4;
			var part4P:Number = part4 - int(part4);
			var jump:Number = spow(power, gln / friction);
			if(gln < 1) {
				return Math.sin(glp * 1.57) * (1 + jump);
			} else {
				if(part4 >= 0 && part4 < 1) {
					return 1 + Math.sin((1 - part4P) * 1.57) * jump;
				}else if(part4 >= 1 && part4 < 2) {
					return 1 + Math.sin(-part4P * 1.57) * jump;
				}else if(part4 >= 2 && part4 < 3) {
					return 1 + Math.sin(-(1 - part4P) * 1.57) * jump;
				}else if(part4 >= 3 && part4 < 4) {
					return 1 + Math.sin(part4P * 1.57) * jump;
				}
			}
			return 0;
		}

		public static function spow(n:Number, spow:Number):Number {
			return n / Math.pow(2, spow - 1);
		}
	}
}
