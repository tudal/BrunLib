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
package pl.brun.lib.display.button {
	import pl.brun.lib.display.button.views.ButtonViewFactoryByLabel;
	import pl.brun.lib.models.IMCOperator;

	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * created:2009-11-20
	 * @author Marek Brun
	 */
	public class MCButton extends SpriteButton implements IMCOperator {

		private var _mc:MovieClip;

		public function MCButton(mc:MovieClip) {
			super(mc);
			this._mc = mc;
			
			addViews(ButtonViewFactoryByLabel.createViewsByLabels(mc));
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		private static const servicedObjects:Dictionary = new Dictionary(true);

		public static function forInstance(mc:MovieClip):MCButton {
			if(!servicedObjects[mc]) {
				servicedObjects[mc] = new MCButton(mc);
			}
			return servicedObjects[mc];
		}
	}
}
