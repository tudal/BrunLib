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
package pl.brun.lib.service {
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.Base;

	import flash.utils.Dictionary;

	/**
	 * When there's some public property changed from one object in another
	 * (for example AnimatedInertialNumber change some MovieClip 'x' property),
	 * you never can be sure, if there's some other object, that already changing
	 * that property of that object.
	 * The solution in such conflict can be allowing only for the lastest "changer"
	 * do the changing of property.
	 * 
	 * Usage:
	 * ObjectEachPropertyOneChangerService.forInstance(mc).setNewChanger(this, 'x');
	 * ObjectEachPropertyOneChangerService.forInstance(mc).setNewPropertyValue(this, 123, 'x');
	 * 
	 * or:
	 * changeService = ObjectEachPropertyOneChangerService.forInstance(mc)
	 * changeService.setNewChanger(this, 'x');
	 * changeService.setNewPropertyValue(this, 123, 'x');
	 * 
	 * @author Marek Brun
	 */
	public class ObjectEachPropertyOneChangerService extends Base {
		private static const servicedObjects:Dictionary = new Dictionary(true);
		private var propertyAndChanger:Dictionary;
		private var obj:Object;

		public function ObjectEachPropertyOneChangerService(access:Private, obj:Object) {
			this.obj = obj
			if (obj is IDisposable) {
				IDisposable(obj).addEventListener(EventPlus.BEFORE_DISPOSED, onObj_BeforeDisposed)
			}
			propertyAndChanger = new Dictionary(true);
		}

		private function onObj_BeforeDisposed(event:EventPlus):void {
			if (servicedObjects[obj]) delete servicedObjects[obj];
			propertyAndChanger = null
		}

		public function setNewChanger(changer:Object, property:String):void {
			propertyAndChanger[property] = changer;
		}

		public function setNewPropertyValue(changer:Object, property:String, value:*):Boolean {
			if (propertyAndChanger[property] == changer) {
				obj[property] = value;
				return true;
			}
			return false;
		}

		public static function forInstance(obj:Object):ObjectEachPropertyOneChangerService {
			if (servicedObjects[obj]) {
				return servicedObjects[obj];
			}
			servicedObjects[obj] = new ObjectEachPropertyOneChangerService(null, obj);
			return servicedObjects[obj];
		}
	}
}
internal class Private {
}