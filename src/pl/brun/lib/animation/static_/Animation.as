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
	import pl.brun.lib.actions.implementations.TimeAction;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.EasingByID;

	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * Events:
	 *  - Event.CHANGE - animation progress changed
	 * 
	 * @author Marek Brun
	 */
	public class Animation extends TimeAction {

		public var name:String;
		public var animOut:Animation;
		private var elements:Array /*of AnimatedProperty*/ = [];
		private var defaultEasing:Easing;

		public function Animation(time:uint = 1000, name:String = null) {
			super(time);
			this.name = name;
		}

		public function setupEaseForAll(easing:Easing):void {
			defaultEasing = easing;
			var i:uint, ele:AnimatedProperty;
			for(i = 0;i < elements.length;i++) {
				ele = elements[i];
				ele.easing = easing;
			}
		}

		public function addProperty(obj:Object, param:String, target:Number, easing:Easing = null):AnimatedProperty {
			if(defaultEasing && easing == null) { 
				easing = defaultEasing; 
			}
			return addPropertyByInstance(new AnimatedProperty(obj, param, target, easing));
		}

		public function addPropertyByInstance(aei:AnimatedProperty):AnimatedProperty {
			ObjectAnimations.forInstance(aei.obj).regAnimation(this);
			elements.push(aei)
			addDisposeChild(aei)
			return aei;
		}

		public function getElements():Array {
			return elements.concat();
		}

		override protected function doRunning():void {
			for(var i:uint = 0,aei:AnimatedProperty;aei = elements[i];i++) {
				if(isNaN(aei.target)) { 
					throw new Error('Can\'t start animation because one AnimatedProperty (' + aei.param + ') have NaN \'target\'');
				}
				ObjectAnimations.forInstance(aei.obj).regRunningAnimationProperty(aei);
				aei.setRunningInAnimation(this);
				aei.reset();
			}
			super.doRunning();
		}

		override protected function doEnterFrame():void {
			var progress:Number = getProgress();
			for(var i:uint = 0,aei:AnimatedProperty;aei = elements[i];i++) {
				aei.setProgress(progress);
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		override protected function doIdle():void {
			for(var i:uint = 0,aei:AnimatedProperty;aei = elements[i];i++) {
				ObjectAnimations.forInstance(aei.obj).unregRunningAnimatedProperty(aei);
				if(isSuccess) {
					aei.applyTargetParam();
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
			super.doIdle();
		}

		public function cloneByTargetsAsCurrents(isMirrorEase:Boolean = false, name:String = null):Animation {
			var anim:Animation = new Animation(runningTime, name);
			for(var i:uint = 0,aei:AnimatedProperty;aei = elements[i];i++) {
				anim.addPropertyByInstance(aei.cloneByTargetAsCurrent(isMirrorEase));
			} 
			return anim;
		}

		public function cloneByNewObject(newObject:Object, name:String = null):Animation {
			var anim:Animation = new Animation(runningTime, name);
			for(var i:uint = 0,aei:AnimatedProperty;aei = elements[i];i++) {
				anim.addPropertyByInstance(aei.cloneByNewObject(newObject));
			} 
			return anim;
		}

		public function setNewTargetByParam(param:String, target:Number):void {
			for(var i:uint = 0,animationsElement:AnimatedProperty;i < elements.length;i++) {
				animationsElement = elements[i];
				if(animationsElement.param == param) {
					animationsElement.target = target;
				}
			}
		}

		public static function createNewDynamicForID(id:String):Animation {
			var anim:Animation = new Animation();
			anim.setupEaseForAll(EasingByID.forID(id).easing);			//anim.runningTime
			//(MLNumberValue.getInstanceForID(id));
			return anim;
		}
		
	}
}