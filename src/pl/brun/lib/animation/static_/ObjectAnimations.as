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
package pl.brun.lib.animation.static_ {
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.util.ArrayUtils;

	import flash.utils.Dictionary;

	public class ObjectAnimations {
		private var obj:Object;
		private var animationsElementsRunning:Object;
		private var animationsElements:Array;
		private static const servicedObjects:Dictionary = new Dictionary(true);
		private var animations:Array;

		public function ObjectAnimations(obj:Object) {
			this.obj = obj;
			if (obj is IDisposable) {
				IDisposable(obj).addEventListener(EventPlus.BEFORE_DISPOSED, onObj_BeforeDisposed)
			}
			animationsElementsRunning = {};
			animationsElements = [];
			animations = [];
		}

		private function onObj_BeforeDisposed(event:EventPlus):void {
			animationsElementsRunning = null
			if (servicedObjects[obj]) delete servicedObjects[obj];
			while(animations.length) animations.pop();
			animations = null
			while(animationsElements.length) animationsElements.pop();
			animationsElements = null
		}

		public function setNewTargetByParam(param:String, target:Number):void {
			for (var i:uint = 0,animationsElement:AnimatedProperty;i < animationsElements.length;i++) {
				animationsElement = animationsElements[i];
				if (animationsElement.param == param) {
					animationsElement.target = target;
				}
			}
		}

		public function regAnimatedProperty(ae:AnimatedProperty):void {
			animationsElements.push(ae);
		}

		public function regRunningAnimationProperty(ae:AnimatedProperty):void {
			if (animationsElementsRunning[ae.param] && animationsElementsRunning[ae.param] != ae) {
				AnimatedProperty(animationsElementsRunning[ae.param]).terminateIfIsRunningInAnimation();
			}
			animationsElementsRunning[ae.param] = ae;
			ae.isBlocked = false;
		}

		public function unregRunningAnimatedProperty(ae:AnimatedProperty):void {
			for (var i:* in animationsElementsRunning) {
				if (i == ae.param) {
					delete animationsElementsRunning[ae.param];
				}
			}
		}

		public function regAnimation(anim:Animation):void {
			ArrayUtils.pushUnique(animations, anim);
		}

		public static function forInstance(obj:Object):ObjectAnimations {
			if (servicedObjects[obj]) {
				return servicedObjects[obj];
			}
			servicedObjects[obj] = new ObjectAnimations(obj);
			return servicedObjects[obj];
		}
	}
}