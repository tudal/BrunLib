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
	import flash.events.IEventDispatcher;
	import pl.brun.lib.Base;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.SinEasing;

	public class AnimatedProperty extends Base {

		public var isBlocked:Boolean;
		public var obj:Object;
		public var param:String;
		public var target:Number;
		public var easing:Easing;
		public var isMirrorEase:Boolean;
		private var init:Number;
		private var dist:Number;
		private var runningIn:Animation;

		public function AnimatedProperty(obj:Object, param:String, target:Number, ease:Easing = null) {
			this.obj = obj;
			this.param = param;
			this.target = target;
			this.easing = ease == null ? new SinEasing() : ease;
		}

		public function reset():void {
			init = obj[param];			dist = target - init;
			isBlocked = false;
			ObjectAnimations.forInstance(obj).regRunningAnimationProperty(this);
		}

		/**
		 * @param n01 from 0 to 1
		 */
		public function setProgress(n01:Number):void {
			if(isBlocked) { 
				return; 
			}
			obj[param] = init + dist * easing.getEasing(n01, isMirrorEase);
		}

		public function applyTargetParam():void {
			if(isBlocked) { 
				return; 
			}
			obj[param] = target;
		}

		public function clone():AnimatedProperty {
			var ae:AnimatedProperty = new AnimatedProperty(obj, param, target, easing);
			return ae;
		}

		public function cloneByTargetAsCurrent(isMirrorEase:Boolean = false):AnimatedProperty {
			var ae:AnimatedProperty = new AnimatedProperty(obj, param, obj[param], easing);
			ae.isMirrorEase = isMirrorEase;
			return ae;
		}

		public function cloneByNewObject(newObject:Object):AnimatedProperty {
			var ae:AnimatedProperty = new AnimatedProperty(newObject, param, target, easing);
			return ae;
		}

		public function setRunningInAnimation(runningIn:Animation):void {
			if(this.runningIn) {
				if(this.runningIn == runningIn) { 
					return; 
				}
				removeEventSubscription(this.runningIn, ActionEvent.RUNNING_START, onRunningInActionStart);
				this.runningIn.finish();
			}
			this.runningIn = runningIn;
			addEventSubscription(this.runningIn, ActionEvent.RUNNING_START, onRunningInActionStart);
		}

		public function terminateIfIsRunningInAnimation():void {
			if(runningIn) {
				runningIn.finish();
			}
		}

		override public function dispose():void {
			obj = null;
			easing = null;
			runningIn = null;
			super.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		protected function onRunningInActionFinish(event:ActionEvent):void {
			removeEventSubscription(IEventDispatcher(event.target), ActionEvent.RUNNING_FINISH, onRunningInActionFinish);
			if(event.target == runningIn) {
				runningIn = null;
			}
		}

		protected function onRunningInActionStart(event:ActionEvent):void {
			addEventSubscription(Animation(event.target), ActionEvent.RUNNING_FINISH, onRunningInActionFinish);
		}
	}
}