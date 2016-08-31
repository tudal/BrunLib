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
package pl.brun.lib.animation.dynamic_ {

	/**
	 * created: 2009-11-29
	 * @author Marek Brun
	 */
	public class AnimatedInertialNumber extends AnimatedNumber {

		/** from 0 to 1, smaller - longer animation */
		public var friction:Number = .4;
		/** from 0 to 1, biger - faster */
		public var acceleration:Number = .5;
		public var speed:Number;

		public function AnimatedInertialNumber(initialCurrentValue:Number = 0) {
			super(initialCurrentValue);
		}

		override protected function doRunning():void {
			speed = 0;
			super.doRunning();
		}

		override protected function canBeFinished():Boolean { 
			if(super.canBeFinished()) {
				return true;
			}
			return Math.abs(target - current) < 0.01 && Math.abs(speed) < 0.001;
		}

		public function setSpeed(speed:Number):void {
			this.speed = speed;
		}

		public function getCurrentSpeed():Number {
			return speed;
		}

		override protected function doAnimationStep(time:uint):void {
			speed += (target - current) * acceleration;
			speed -= speed * friction;
			current += speed;
		}
	}
}