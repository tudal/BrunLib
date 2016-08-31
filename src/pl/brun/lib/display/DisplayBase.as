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
package pl.brun.lib.display {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.IDisplayObjectOperator;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * created: 2009-11-29
	 * @author Marek Brun
	 */
	public class DisplayBase extends Base implements IDisplayObjectOperator {

		private var _holder:Sprite;
		private static var countNames:uint = 0;

		public function DisplayBase(holder:Sprite = null) {
			_holder = holder ? holder : new Sprite();
			//detecting and changind automatic instance name to class name
			//for easier debugging 
			if(_holder.name.substr(0, 'instance'.length) == 'instance') {
				try {
					_holder.name = getQualifiedClassName(this).split('::')[1] + String(countNames++);
				}catch(e:*) {
				}
			}
			if(!this.container) {
				throw IllegalOperationError('?');
			}
			dbgName = _holder.name
		}

		/*abstract*/
		/**
		 * WARNING: execute checkStage() o use this method 
		 */
		protected function doOnAddedToStage():void {
		}

		protected function checkStage():void {
			if(container.stage) {
				doOnAddedToStage();
			} else {
				container.addEventListener(Event.ADDED_TO_STAGE, onHolder_AddedToStage, false, 0, true);
			}
		}

		public function get container():Sprite {
			return _holder;
		}

		public function get display():DisplayObject {
			return _holder;
		}

		public function get d():DisplayObject {
			return _holder;
		}

		override public function dispose():void {
			//DisplayUtils.disposeDisplay(container);
			if(isDisposed) return;
			if(container.parent) container.parent.removeChild(container);
			_holder = null;
			super.dispose();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onHolder_AddedToStage(event:Event):void {
			doOnAddedToStage();
		}
	}
}
