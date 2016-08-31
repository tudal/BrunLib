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
	public class AnimatedStoppingNumber extends AnimatedNumber {

		/** from 0 to 1, bigger - faster */
		public var speed:Number = .5;
		/** Sets the minimal distance from current to target to set finish. */
		public var minDistToTarget:Number = 0.001;

		public function AnimatedStoppingNumber(initialCurrentValue:Number = 0) {
			super(initialCurrentValue);
		}

		override protected function doRunning():void {
			super.doRunning();
		}

		override protected function canBeFinished():Boolean { 
			if(super.canBeFinished()) {
				return true;
			}
			return Math.abs(target - current) < minDistToTarget;
		}

		override protected function doAnimationStep(time:uint):void {
			var num:Number = current;
			//num += ((target - num) * speed) * Math.max(0, Math.min(.95, (time / 1000) * 8));
			num += (target - num) * speed
			current = num;
		}
	}
}