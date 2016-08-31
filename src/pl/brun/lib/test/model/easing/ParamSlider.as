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
package pl.brun.lib.test.model.easing {
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.EasingParamVO;

	import flash.events.Event;

	/**
	 * Events:
	 *  - Event.CHANGE
	 * 
	 * created: 2009-11-29
	 * @author Marek Brun
	 */
	public class ParamSlider extends DisplayBase {

		private var mc:EasingParamSliderMC;
		private var param:EasingParamVO;
		private var easing:Easing;

		public function ParamSlider() {
			mc = new EasingParamSliderMC();
			container.addChild(mc);
			
			mc.sliderValue.addEventListener(Event.CHANGE, onSliderValue_Change);
		}

		public function getHeight():Number {
			return mc.heightSetter.height;
		}

		public function setParamAndEasing(param:EasingParamVO, easing:Easing):void {

			this.param = param;
			this.easing = easing;
			
			mc.labelName.text = param.fieldName;
			mc.sliderValue.maximum = param.max;
			mc.sliderValue.minimum = param.min;
			mc.sliderValue.value = easing[param.fieldName];
			mc.labelValue.text = Number(easing[param.fieldName]).toFixed(3);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onSliderValue_Change(event:Event):void {
			easing[param.fieldName] = mc.sliderValue.value;
			mc.labelValue.text = Number(easing[param.fieldName]).toFixed(3);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}
