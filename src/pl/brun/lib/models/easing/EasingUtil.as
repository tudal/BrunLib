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
	public class EasingUtil {

		public static function getParamsByClass(clazz:Class):Array /*of EasingParamVO*/ {
			switch(clazz) {
				case PowEasing:
					return [new EasingParamVO('pow', 0, 10),];
					break;
				case Bezier2Easing:
					return [new EasingParamVO('one', -2, 2),						new EasingParamVO('two', -2, 2),];
					break;
				case LogEasing:
					return [new EasingParamVO('x', 0, 1)];
					break;
				case Bezier3Easing:
					return [new EasingParamVO('one', -2, 2),
						new EasingParamVO('two', -2, 2),						new EasingParamVO('three', -2, 2),];
					break;
				case BounceEasing:
					return [new EasingParamVO('humps', 1, 40),
						new EasingParamVO('power', 0, 5),
						new EasingParamVO('friction', 0, 3),];
					break;
				case ElasticEasing:
					return [new EasingParamVO('humps', 1, 40),
						new EasingParamVO('dynamic_', 0, 5),						new EasingParamVO('power', 0, 3),
						new EasingParamVO('friction', 0, 3),];
					break;
				case EdgeEasing:
					return [new EasingParamVO('edge', 0, 5)];
					break;
			}
			return [];
		}

		public static function getEasingClasses():Array /*of Class*/ {
			return [Easing,
				SinEasing,
				PowEasing,
				LogEasing,				CircleEasing,				EdgeEasing,				Bezier2Easing,				Bezier3Easing,				ElasticEasing,
				BounceEasing,];
		}
	}
}