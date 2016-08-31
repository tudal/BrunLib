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
	import pl.brun.lib.commands.CallCmd;
	import pl.brun.lib.commands.ICommand;
	import pl.brun.lib.display.ObjectByDisplayDisposer;
	import pl.brun.lib.models.IDisplayObjectOperator;
	import pl.brun.lib.service.FTS;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	[Event(name="click", type="flash.events.MouseEvent")];
	[Event(name="touchTap", type="flash.events.TouchEvent")]
	/**
	 * Events:
	 *  - MouseEvent.CLICK
	 * 
	 * created:2009-11-17
	 * @author Marek Brun
	 */
	public class InteractiveObjectButton extends ButtonModel implements IDisplayObjectOperator {
		public var isClickEnabled:Boolean = true;
		private var _display:InteractiveObject;
		private var clickCommands:Array /*of ICommand*/ 
		= [];
		private var pressParentMouseX:Number = 0;
		private var pressParentMouseY:Number = 0;
		private var _pressX:Number = 0;
		private var _pressY:Number = 0;
		private var pressStageMouseX:Number = 0;
		private var pressStageMouseY:Number = 0;
		private var lastParentMouseX:Number = 0;
		private var lastParentMouseY:Number = 0;
		private var lastStageMouseX:Number = 0;
		private var lastStageMouseY:Number = 0;
		private var currentParentMouseX:Number = 0;
		private var currentParentMouseY:Number = 0;
		private var currentStageMouseX:Number = 0;
		private var currentStageMouseY:Number = 0;
		private var lastClickFrameNumber:Number;

		public function InteractiveObjectButton(display:InteractiveObject) {
			this._display = display
			addEventSubscription(display, MouseEvent.MOUSE_DOWN, onDisplay_MouseDown)
			addEventSubscription(display, MouseEvent.ROLL_OVER, onDisplay_RollOver)
			addEventSubscription(display, MouseEvent.ROLL_OUT, onDisplay_RollOut)
			addEventSubscription(display, MouseEvent.CLICK, onDisplay_Click)

			//addEventSubscription(display, TouchEvent.TOUCH_TAP, onDisplay_Tap)

			ObjectByDisplayDisposer.addToDispose(display, this)

			saveLastMousePosition()
		}

		override protected function doPress():void {
			pressParentMouseX = display.parent.mouseX;
			pressParentMouseY = display.parent.mouseY;
			pressStageMouseX = display.stage.mouseX;
			pressStageMouseY = display.stage.mouseY;
			_pressX = display.x;
			_pressY = display.y;
			saveLastMousePosition();
			addEventSubscription(display.stage, MouseEvent.MOUSE_UP, onStage_MouseUp_WhilePress);
		}

		override protected function doDragMove():void {
			saveLastMousePosition();
		}

		override protected function doDisabled():void {
			_display.mouseEnabled = false;
		}

		override protected function doEnabled():void {
			_display.mouseEnabled = true;
		}

		private function saveLastMousePosition():void {
			lastParentMouseX = currentParentMouseX;
			lastParentMouseY = currentParentMouseY;
			if(display.parent) {
				currentParentMouseX = display.parent.mouseX;
				currentParentMouseY = display.parent.mouseY;
			}
			if(display.stage) {
				lastStageMouseX = currentStageMouseX;
				lastStageMouseY = currentStageMouseY;
				currentStageMouseX = display.stage.mouseX;
				currentStageMouseY = display.stage.mouseY;
			}
		}

		public function get dragMoveX():Number {
			if(!display.parent) {
				return 0;
			}
			return currentStageMouseX - lastParentMouseX;
		}

		public function get dragMoveY():Number {
			if(!display.parent) {
				return 0;
			}
			return currentStageMouseY - lastParentMouseY
		}

		public function get moveX():Number {
			if(!display.parent) {
				return 0;
			}
			return display.parent.mouseX - pressParentMouseX;
		}

		public function get moveY():Number {
			if(!display.parent) {
				return 0;
			}
			return display.parent.mouseY - pressParentMouseY;
		}

		public function get stageMoveX():Number {
			if(!display.stage) {
				return 0;
			}
			return display.stage.mouseX - pressStageMouseX;
		}

		public function get stageMoveY():Number {
			if(!display.stage) {
				return 0;
			}
			return display.stage.mouseY - pressStageMouseY;
		}

		public function get pressX():Number {
			return _pressX;
		}

		public function get pressY():Number {
			return _pressY;
		}

		public function addClickCommand(command:ICommand):void {
			clickCommands.push(command);
		}

		public function addClickCall(method:Function, args:Array/*of * */ 
		= null):CallCmd {
			var callCmd:CallCmd = new CallCmd(method, args);
			clickCommands.push(callCmd);
			return callCmd;
		}

		public function removeAllClickCommands():void {
			clickCommands = [];
		}

		public function get display():DisplayObject {
			return _display;
		}

		public function get d():DisplayObject {
			return _display;
		}

		override public function dispose():void {
			clickCommands = null;
			super.dispose();
			DisplayUtils.disposeDisplay(display);
			_display = null;
		}

		private function onDisplay_RollOut(event:MouseEvent):void {
			rollOut();
		}

		private function onDisplay_RollOver(event:MouseEvent):void {
			rollOver();
		}

		private function onDisplay_MouseDown(event:MouseEvent):void {
			press();
		}

		private function onStage_MouseUp_WhilePress(event:MouseEvent):void {
			removeEventSubscription(EventDispatcher(event.target), MouseEvent.MOUSE_UP, onStage_MouseUp_WhilePress);
			release();
		}

		private function onDisplay_Click(event:MouseEvent):void {
			doClick()
		}

		/*private function onDisplay_Tap(event:TouchEvent):void {
			doClick()
		}*/

		private function doClick():void {
			var frameNumber:Number = FTS.getInstance().getFrameNumber()
			if(frameNumber == lastClickFrameNumber) {
				return
			}
			lastClickFrameNumber = frameNumber

			var i:uint;
			var command:ICommand;
			for(i = 0;clickCommands && i < clickCommands.length;i++) {
				command = clickCommands[i];
				command.execute();
			}
			if(isClickEnabled) {
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
		}
	}
}
