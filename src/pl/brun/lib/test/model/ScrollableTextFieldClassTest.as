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
package pl.brun.lib.test.model {
	import pl.brun.lib.util.KeyCode;
	import pl.brun.lib.controller.ScrollController;
	import pl.brun.lib.display.ui.scroller.Scroller;
	import pl.brun.lib.models.ScrollableTextField;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.TestUtils;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class ScrollableTextFieldClassTest extends TestBase {

		private var mc:ScrollableTextFieldClassTestMC;
		private var scrollController:ScrollController;
		private var tfScrollModel:ScrollableTextField;
		private var scroller:Scroller;
		
		override protected function init():void {
			super.init()
			
			mc = new ScrollableTextFieldClassTestMC();
			holder.addChild(mc);
			
			tfScrollModel = new ScrollableTextField(mc.tf);
			scroller = new Scroller(mc.scroller);
			scrollController = new ScrollController(tfScrollModel, scroller);
			
			addTestKey(KeyCode.T, setRandomTextToTF, null, 'setRandomTextToTF();');			addTestKey(KeyCode.R, resizeTF, null, 'resizeTF();');
			
			setRandomTextToTF();
		}

		private function resizeTF():void {
			mc.tf.height = 100 + Math.random() * 800;
			scroller.size = mc.tf.height;
			tfScrollModel.afterChange();
		}

		private function setRandomTextToTF():void {
			mc.tf.text = TestUtils.getRandomText(40);
		}
	}
}
