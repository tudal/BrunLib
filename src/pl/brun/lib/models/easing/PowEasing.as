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
	public class PowEasing extends Easing {

		public var pow:Number = 2;

		override protected function calculateEasing(input:Number):Number {
			return Math.max(Math.pow(input, pow), 0);
		}
	}
}
