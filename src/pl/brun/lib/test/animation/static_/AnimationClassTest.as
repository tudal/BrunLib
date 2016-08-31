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
package pl.brun.lib.test.animation.static_ {
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.animation.static_.Animation;
	import pl.brun.lib.models.easing.PowEasing;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/**
	 * created: 2009-12-09
	 * @author Marek Brun
	 */
	public class AnimationClassTest extends TestBase {
		private var mc:AnimationClassTestMC;
		private var animToA:Animation;
		private var animToB:Animation;
		private var selectedFilters:Array;

		public function AnimationClassTest() {
			mc = new AnimationClassTestMC();
			holder.addChild(mc);

			selectedFilters = [new GlowFilter(0x00FF00, 1)];

			animToA = new Animation();
			var easing:PowEasing = new PowEasing()
			easing.pow = 10
			easing.isDouble = true
			easing.isMirror = true
			animToA.addProperty(mc.ball, 'x', mc.a.x, easing);
			animToA.addProperty(mc.ball, 'y', mc.a.y);
			animToA.addEventListener(ActionEvent.RUNNING_FINISH, onAnimtoA_RunningFinish)

			animToB = new Animation(500);
			animToB.addProperty(mc.ball, 'x', mc.b.x);
			animToB.addProperty(mc.ball, 'y', mc.b.y).isMirrorEase = true;

			mc.btnAnimToA.addEventListener(MouseEvent.CLICK, onBtnAnimToA_Click);
			mc.btnAnimToB.addEventListener(MouseEvent.CLICK, onBtnAnimToB_Click);
		}

		private function onAnimtoA_RunningFinish(event:ActionEvent):void {
			dbg.log("onAnimtoA_RunningFinish(" + dbg.linkArr(arguments, true) + ')')
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onBtnAnimToB_Click(event:MouseEvent):void {
			animToB.start();
			mc.a.filters = [];
			mc.b.filters = selectedFilters;
		}

		private function onBtnAnimToA_Click(event:MouseEvent):void {
			animToA.start();
			mc.a.filters = selectedFilters;
			mc.b.filters = [];
		}
	}
}
