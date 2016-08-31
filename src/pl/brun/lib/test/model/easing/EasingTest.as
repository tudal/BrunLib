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
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.EasingParamVO;
	import pl.brun.lib.models.easing.EasingUtil;
	import pl.brun.lib.test.TestBase;

	import flash.events.Event;

	/**
	 * created: 2009-11-29
	 * @author Marek Brun
	 */
	public class EasingTest extends TestBase {

		private var mc:EasingTestMC;
		private var easingClasses:Array /*of Class*/= [];
		private var currentEasing:Easing;
		private var isMirror:Boolean;
		private var paramSliders:Array /*of ParamSlider*/ = [];
		private var isDouble:Boolean;

		public function EasingTest() {
			mc = new EasingTestMC();
			holder.addChild(mc);
			
			easingClasses = EasingUtil.getEasingClasses();
			
			var i:uint;
			for(i = 0;i < easingClasses.length;i++) {
				mc.comboEaseType.addItem({data:easingClasses[i], label:String(easingClasses[i])});
			}
			
			mc.comboEaseType.addEventListener(Event.CHANGE, onComboEaseType_Change);			mc.checkIsMirror.addEventListener(Event.CHANGE, onCheckIsMirror_Change);			mc.checkIsDouble.addEventListener(Event.CHANGE, onCheckIsDouble_Change);
			
			setCurrentEasingByIndex(0);
			
			drawChecks();
			applyProperties();
		}

		private function drawChecks():void {
			mc.checkIsMirror.selected = isMirror;			mc.checkIsDouble.selected = isDouble;
		}

		private function applyProperties():void {
			currentEasing.isMirror = isMirror;			currentEasing.isDouble = isDouble;
		}

		private function setCurrentEasingByIndex(index:uint):void {
			setCurrentEasing(new easingClasses[index]());
		}

		private function setCurrentEasing(easing:Easing):void {
			currentEasing = easing;
			
			mc.comboEaseType.selectedIndex = easingClasses.indexOf(Object(currentEasing).constructor);
			
			var params:Array /*of EasingParamVO*/ = EasingUtil.getParamsByClass(Class(Object(currentEasing).constructor));
			
			dbg.log('params:' + dbg.link(params));
			
			var i:uint;
			var param:EasingParamVO;
			var paramSlider:ParamSlider;
			for(i = 0;i < params.length;i++) {
				param = params[i];
				if(!paramSliders[i]) {
					paramSlider = new ParamSlider();
					paramSlider.addEventListener(Event.CHANGE, onParamSlider_Change);
					paramSliders[i] = paramSlider;
					paramSlider.container.y = i * paramSlider.getHeight();
					mc.paramSliders.addChild(paramSlider.container);
				}
				paramSlider = paramSliders[i];
				mc.paramSliders.addChild(paramSlider.container);
				paramSlider.setParamAndEasing(param, currentEasing);
			}
			
			for(i = params.length;i < paramSliders.length;i++) {
				paramSlider = paramSliders[i];
				if(paramSlider.container.parent) {
					mc.paramSliders.removeChild(paramSlider.container);
				}
			}
			
			applyProperties();
			drawChart();
		}

		private function drawChart():void {
			mc.chart.graphics.clear();
			mc.chart.graphics.lineStyle(0, 0x000000, 1);
			mc.chart.graphics.moveTo(0, mc.chart.bg.height);
			var i:Number;
			for(i = 0;i < 100;i += 0.1) {
				mc.chart.graphics.lineTo(i / 100 * mc.chart.bg.width, mc.chart.bg.height - currentEasing.getEasing(i / 100) * mc.chart.bg.height);
			}
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onComboEaseType_Change(event:Event):void {
			setCurrentEasingByIndex(mc.comboEaseType.selectedIndex);
		}

		private function onCheckIsMirror_Change(event:Event):void {
			isMirror = !isMirror;
			drawChecks();
			applyProperties();
			drawChart();
		}

		private function onCheckIsDouble_Change(event:Event):void {
			isDouble = !isDouble;
			drawChecks();
			applyProperties();
			drawChart();
		}

		private function onParamSlider_Change(event:Event):void {
			drawChart();
		}
	}
}