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
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * created:2009-11-17
	 * @author Marek Brun
	 */
	public class SpriteButton extends InteractiveObjectButton {

		private var _sprite:Sprite;

		public function SpriteButton(sprite:Sprite) {
			super(sprite);
			this._sprite = sprite;
			
			sprite.tabEnabled = true;
			sprite.useHandCursor = true;
			sprite.buttonMode = true;
			sprite.mouseChildren = false;
		}

		private static const servicedObjects:Dictionary = new Dictionary(true);

		public static function forInstance(sprite:Sprite):SpriteButton {
			if(!servicedObjects[sprite]) {
				servicedObjects[sprite] = new SpriteButton(sprite);
			}
			return servicedObjects[sprite];
		}

		override protected function doDisabled():void {
			_sprite.mouseEnabled = false;
			super.doDisabled();
		}

		override protected function doEnabled():void {
			_sprite.mouseEnabled = true;
			super.doEnabled();
		}

		public function get sprite():Sprite {
			return _sprite;
		}
	}
}
