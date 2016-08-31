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
	import pl.brun.lib.util.DisplayUtils;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.models.IContainerOperator;
	import pl.brun.lib.models.IDisplayObjectOperator;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	/**
	 * Every display object from child action which implements IDisplayObjectOperator
	 * will be added (and removed) to container passed in constructor.
	 * 
	 * created:2009-10-31 
	 * @author Marek Brun
	 */
	public class DisplayAction extends Action implements IContainerOperator {

		private var _container:Sprite;		private var dictNoAdd:Dictionary = new Dictionary(true);
		private var subContainer:DisplayObjectContainer;

		public function DisplayAction(container:Sprite, isSubContainer:Boolean = false) {
			if(isSubContainer) {
				this.subContainer = new Sprite();
				subContainer.addChild(container);
			}
			this._container = container;
		}

		override protected function doChildActionStartRunning(childAction:Action):void {
			if(childAction is IDisplayObjectOperator) {
				if(dictNoAdd[childAction]) {
					return;
				}
				_container.addChild(IDisplayObjectOperator(childAction).display);
			}
		}

		override protected function doChildActionFinishRunning(childAction:Action):void {
			if(childAction is IDisplayObjectOperator) {
				if(dictNoAdd[childAction]) {
					return;
				}
				var cad : DisplayObject=IDisplayObjectOperator(childAction).display
				if(cad.parent && cad.parent==_container){
					_container.removeChild(cad);
				}
			}
		}

		public function registerToAutoAddDisplay(action:Action):void {
			if(!(action is IDisplayObjectOperator)) {
				throw new ArgumentError('Passed \'action\' must implement IDisplayObjectOperator');
			}
			addEventSubscription(action, ActionEvent.RUNNING_START, onAction_RunningStart);
		}

		public function noAutoAddDisplay(action:Action):void {
			dictNoAdd[action] = true;
		}

		public function get holder():DisplayObjectContainer {
			return _container;
		}

		public function get display():DisplayObject {
			return subContainer ? subContainer : _container;
		}

		public function get d():DisplayObject {
			return display;
		}
		
		public function get container():Sprite {
			return _container;
		}

		override public function dispose():void {
			dictNoAdd = null;
			subContainer = null;
			if(subContainer){
				DisplayUtils.disposeDisplay(subContainer)			}else{
				DisplayUtils.disposeDisplay(container)
			}
			super.dispose();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onAction_RunningStart(event:ActionEvent):void {
			addEventSubscription(Action(event.target), ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
			holder.addChild(IDisplayObjectOperator(event.target).display);
		}

		private function onAction_RunningFinish_WhileAdded(event:ActionEvent):void {
			removeEventSubscription(Action(event.target), ActionEvent.RUNNING_FINISH, onAction_RunningFinish_WhileAdded);
			holder.removeChild(IDisplayObjectOperator(event.target).display);
		}
	}
}
