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
	import pl.brun.lib.actions.implementations.EnterFrameAction;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.service.ObjectEachPropertyOneChangerService;

	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * Base class for frame based animation where target value can be changed
	 * during animation running.
	 */
	public class AnimatedNumber extends EnterFrameAction {
		/**
		 * when true - mapped properties is also animated on ints
		 * Calculations is still on Number. 
		 */
		public var isMappedToInt:Boolean = false;
		/**
		 * when true - action is started with every change of target value
		 * (dosent include auto update target)
		 */
		public var isAutoStart:Boolean = true;
		private var autoMappings:Array /*of Array of [Object, String]*/ 
		= [];
		private var initialValueSource:Array /*of [Object, String]*/;
		private var autoUpdateTarget:Array /*of [Object, String]*/;
		private var targetValue:Number = 0;
		private var _current:Number = 0;
		private var countMappings:Number = 1;
		private var isCancel:Boolean;

		public function AnimatedNumber(currentValue:Number) {
			current = currentValue;
		}

		/*abstract*/
		protected function doAnimationStep(time:uint):void {
		}

		override protected function doEnterFrame():void {
			if (autoUpdateTarget) {
				target = autoUpdateTarget[0][autoUpdateTarget[1]];
			}
			doAnimationStep(RootProvider.getLastFrameDuration());
			dispatchEvent(new Event(Event.CHANGE));

			if (canBeFinished()) {
				finish();
			}
		}

		override protected function canBeFinished():Boolean {
			if (isCancel) {
				return true;
			}
			if (autoMappings.length) {
				return countMappings == 0;
			}
			return false;
		}

		public function set target(num:Number):void {
			if (isNaN(num)) {
				throw new ArgumentError('Passed value can\'t be NaN');
			}
			if (num == Number.POSITIVE_INFINITY || num == Number.NEGATIVE_INFINITY) {
				throw new ArgumentError('Passed value can\'t be infinity');
			}
			targetValue = num;
			if (isAutoStart) {
				start();
			}
		}

		public function get target():Number {
			return targetValue;
		}

		public function set current(num:Number):void {
			if (isNaN(num)) {
				throw new ArgumentError('Passed value can\'t be NaN');
			}
			if (_current == num) {
				return;
			}
			_current = num;
			var currentTmp:Number = isMappedToInt ? Math.round(_current) : _current;
			countMappings = 0;
			if (autoMappings) {
				for (var i:uint = 0,autoMapping:Array;i < autoMappings.length;i++) {
					autoMapping = autoMappings[i];
					if (ObjectEachPropertyOneChangerService.forInstance(autoMapping[0]).setNewPropertyValue(this, autoMapping[1], currentTmp)) {
						countMappings++;
					}
				}
			}
			if (canBeFinished()) {
				finish();
			}
		}

		public function get current():Number {
			return _current;
		}

		override protected function doRunning():void {
			if (autoUpdateTarget) {
				target = autoUpdateTarget[0][autoUpdateTarget[1]];
			}

			for (var i:uint = 0,autoMapping:Array;i < autoMappings.length;i++) {
				autoMapping = autoMappings[i];
				ObjectEachPropertyOneChangerService.forInstance(autoMapping[0]).setNewChanger(this, autoMapping[1]);
			}
			if (initialValueSource) {
				_current = initialValueSource[0][initialValueSource[1]];
			}
			super.doRunning();
		}

		override protected function doIdle():void {
			current = target
			super.doIdle()
		}

		/**
		 * Force finish of action.
		 * Usable when creator is disposing.
		 */
		public function cancel():void {
			isCancel = true;
			targetValue = current
			finish();
			isCancel = false;
		}

		/**
		 * With every start, the target value will be changed to actual
		 * obj[propertyName] value. 
		 */
		public function setAutoUpdateTarget(obj:Object, propertyName:String):void {
			autoUpdateTarget = [obj, propertyName];
		}

		/**
		 * With every start, the current value will be changed to actual
		 * obj[propertyName] value. 
		 */
		public function setInitialValueSource(obj:Object, propertyName:String):void {
			initialValueSource = [obj, propertyName];
		}

		override public function dispose():void {
			while (autoMappings.length>0){
				autoMappings.pop();
			}
			while (initialValueSource && initialValueSource.length>0){
				initialValueSource.pop();
			}
			while (autoUpdateTarget && autoUpdateTarget.length){
				autoUpdateTarget.pop();
			}
			super.dispose()
		}

		/**
		 * @param obj - (public) property owner
		 * @param propertyName - mapped property name
		 * @param isAlsoInitialSource - when true - see setInitialValueSource
		 */
		public function addAutoMapping(obj:Object, propertyName:String, isAlsoInitialSource:Boolean = true):void {
			autoMappings.push([obj, propertyName]);
			if (isAlsoInitialSource) {
				setInitialValueSource(obj, propertyName);
			}
		}
	}
}