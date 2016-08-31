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
package pl.brun.lib.display.libraryItems {
	import pl.brun.lib.display.button.ButtonModel;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.display.button.SpriteButton;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * pl.brun.lib.display.libraryItems.LinkedMCButton
	 * 
	 * @author Marek Brun
	 */
	public class LinkedMCButton extends MCDetectable {

		private var mc:MovieClip;
		private var _model:SpriteButton;

		public function LinkedMCButton() {
			TextField.prototype;
			
			_model = MCButton.forInstance(this);
			
			mc = MovieClip(this);
			
			//if button clip contains clip with instance name "hit" then he will become
			//automatically button clip "hitArea"
			if(mc.hit) {
				mc.hitArea = mc.hit;
			}
			
			dispatchCreatedEvent();
		}

		public function get model():ButtonModel {
			return _model;
		}
	}
}
