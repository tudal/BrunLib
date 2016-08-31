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
package pl.brun.lib.actions.implementations {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.models.IDisplayObjectOperator;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * Every display object from child action which implements IDisplayObjectOperator
	 * will be added (and removed) to container passed in constructor.
	 * 
	 * Instance will be automatically disposed just after finish.
	 * 
	 * created:2009-10-31 
	 * @author Marek Brun
	 */
	public class ContainerAndOneTimeAction extends Action implements IDisplayObjectOperator {

		private var container:DisplayObjectContainer;

		public function ContainerAndOneTimeAction(container:DisplayObjectContainer) {
			this.container = container;
		}

		override protected function doChildActionStartRunning(childAction:Action):void {
			if(childAction is IDisplayObjectOperator) {
				container.addChild(IDisplayObjectOperator(childAction).display);
			}
		}

		override protected function doChildActionFinishRunning(childAction:Action):void {
			if(childAction is IDisplayObjectOperator) {
				container.removeChild(IDisplayObjectOperator(childAction).display);
			}
		}

		public function get display():DisplayObject {
			return container;
		}

		override protected function canBeRestarted():Boolean {
			return false;
		}

		override  protected function isDisposeAfterFinishWithNoRestart():Boolean {
			return true;
		}

		override public function dispose():void {
			DisplayUtils.disposeDisplay(display);
			super.dispose();
		}
	}
}
