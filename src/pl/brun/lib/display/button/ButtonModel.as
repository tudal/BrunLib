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
	import pl.brun.lib.Base;
	import pl.brun.lib.display.button.views.AbstractButtonView;
	import pl.brun.lib.models.IEnablable;

	[Event(name="over", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="moveOver", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="press", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="dragMove", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="dragOut", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="dragOver", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="release", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="releaseOver", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="releaseOutside", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="out", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="disable", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="enable", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="freeze", type="pl.brun.lib.display.button.ButtonEvent")]
	[Event(name="unfreeze", type="pl.brun.lib.display.button.ButtonEvent")]
	/**
	 * Events:
	 *  - ButtonEvent.OVER
	 *  - ButtonEvent.MOVE_OVER
	 *  - ButtonEvent.PRESS
	 *  - ButtonEvent.DRAG_MOVE
	 *  - ButtonEvent.DRAG_OUT
	 *  - ButtonEvent.DRAG_OVER
	 *  - ButtonEvent.RELEASE
	 *  - ButtonEvent.RELEASE_OVER
	 *  - ButtonEvent.RELEASE_OUTSIDE
	 *  - ButtonEvent.OUT
	 *  - ButtonEvent.DISABLE
	 *  - ButtonEvent.ENABLE
	 *  - ButtonEvent.FREEZE
	 *  - ButtonEvent.UNFREEZE
	 * 
	 * created:2009-11-17 
	 * @author Marek Brun
	 */
	public class ButtonModel extends Base implements IEnablable {
		public static var touchMode:Boolean;
		private namespace state;
		use namespace state;
		state var currentState:AbstractState;
		state var previousState:AbstractState;
		public var buttonViews:Array /*of AbstractButtonView*/ 
		= [];

		public function ButtonModel() {
			setState(new OutState(this, state));
		}

		public function rollOver():void {
			currentState.over();
		}

		public function rollOut():void {
			currentState.out();
		}

		public function press():void {
			currentState.press();
		}

		public function release():void {
			currentState.release();
		}

		protected function freezeOver():void {
			currentState.overFreeze();
		}

		public function get isPressed():Boolean {
			return currentState is PressedState;
		}

		public function get isOver():Boolean {
			return currentState is OverState || currentState is OverFreezeState;
		}

		public function get isFreeze():Boolean {
			return currentState is OverFreezeState;
		}

		public function set isFreeze(value:Boolean):void {
			if (isFreeze == value) {
				return;
			}
			if (value) {
				setState(new OverFreezeState(this, state));
			} else {
				setState(new OutState(this, state));
			}
		}

		public function get isEnabled():Boolean {
			return !(currentState is DisabledState);
		}

		public function set isEnabled(value:Boolean):void {
			if (isEnabled == value) {
				return;
			}
			if (value) {
				doEnabled_ns();
				if (!isFreeze) {
					setState(new OutState(this, state));
				}
			} else {
				if (currentState is OverState) {
					setState(new OutState(this, state));
				}
				setState(new DisabledState(this, state));
			}
		}

		public function addViews(views:Array/*of AbstractButtonView*/):void {
			var i:uint;
			var view:AbstractButtonView;
			for (i = 0;i < views.length;i++) {
				view = views[i];
				addView(view);
			}
		}

		public function addView(buttonView:AbstractButtonView):void {
			buttonView.setModel(this);
			pushUnique(buttonViews, buttonView);
		}

		public function removeView(buttonView:AbstractButtonView):void {
			remove(buttonViews, buttonView);
		}

		/*abstract*/
		protected function doOver():void {
		}

		/*abstract*/
		protected function doOut():void {
		}

		/*abstract*/
		protected function doPress():void {
		}

		/*abstract*/
		protected function doRelease():void {
		}

		/*abstract*/
		protected function doFreeze():void {
		}

		/*abstract*/
		protected function doUnfreeze():void {
		}

		/*abstract*/
		protected function doDisabled():void {
		}

		/*abstract*/
		protected function doEnabled():void {
		}

		/*abstract*/
		protected function doDragMove():void {
		}

		state function doOver_ns():void {
			doOver();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setRollOver();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.OVER));
		}

		state function doMouseMoveOver_ns():void {
			dispatchEvent(new ButtonEvent(ButtonEvent.MOVE_OVER));
		}

		state function doDragMove_ns():void {
			doDragMove();
			dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_MOVE));
		}

		state function doDragOut_ns():void {
			dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_OUT));
		}

		state function doDragOver_ns():void {
			dispatchEvent(new ButtonEvent(ButtonEvent.DRAG_OVER));
		}

		state function doOut_ns():void {
			doOut();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setRollOut();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.OUT));
		}

		state function doPress_ns():void {
			doPress();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setPress();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
		}

		state function doRelease_ns():void {
			doRelease();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setRelease();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
		}

		state function doReleaseOver_ns():void {
			dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OVER));
		}

		state function doReleaseOutside_ns():void {
			dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE));
		}

		state function doFreeze_ns():void {
			doFreeze();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setFreeze();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.FREEZE));
		}

		state function doUnfreeze_ns():void {
			doUnfreeze();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setUnfreeze();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.UNFREEZE));
		}

		state function doEnabled_ns():void {
			doEnabled();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setEnabled();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.ENABLE));
		}

		state function doDisabled_ns():void {
			doDisabled();
			var i:uint;
			for (i = 0;i < buttonViews.length;i++) {
				AbstractButtonView(buttonViews[i]).setDisabled();
			}
			dispatchEvent(new ButtonEvent(ButtonEvent.DISABLE));
		}

		state function setState(state:AbstractState):void {
			if (currentState) {
				if (Object(currentState).constructor == Object(state).constructor) {
					return;
				}
				previousState = currentState;
				previousState.dispose();
			}

			currentState = state;
			if (previousState) {
				if (Object(previousState).constructor != DisabledState || currentState is DisabledState) {
					currentState.callImplementation();
				}
			}
		}

		public static function pushUnique(arr:Array, value:*):Boolean {
			if (arr.indexOf(value) == -1) {
				arr.push(value);
				return true;
			}
			return false;
		}

		public static function remove(arr:Array, value:*):Boolean {
			var i:uint, isRemove:Boolean;
			while ((i = arr.indexOf(value)) != -1) {
				isRemove = true;
				arr.splice(i, 1);
			}
			return isRemove;
		}

		override public function dispose():void {
			if (currentState) {
				currentState.dispose();
				currentState = null;
			}
			buttonViews = null;
			super.dispose();
		}

		public function enable():void {
			isEnabled = true;
		}

		public function disable():void {
			isEnabled = false;
		}
	}
}
import pl.brun.lib.display.button.ButtonModel;
import pl.brun.lib.managers.RootProvider;

import flash.display.DisplayObject;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

// ------------------------------------------------------------------------------
class AbstractState {
	protected var button:ButtonModel;
	protected var ns:Namespace;
	protected var isDisposed:Boolean;

	function AbstractState(buttonModel:ButtonModel, ns:Namespace) {
		this.button = buttonModel;
		this.ns = ns;
	}

	public function over():void {
	}

	public function out():void {
	}

	public function press():void {
	}

	public function release():void {
	}

	public function overFreeze():void {
		button.ns::setState(new OverFreezeState(button, ns));
	}

	public function callImplementation():void {
	}

	public function dispose():void {
		isDisposed = true
		button = null;
		ns = null;
	}
}
// ------------------------------------------------------------------------------
class OutState extends AbstractState {
	public function OutState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
	}

	override public function over():void {
		button.ns::setState(new OverState(button, ns));
	}

	override public function callImplementation():void {
		button.ns::doOut_ns();
	}
}
// ------------------------------------------------------------------------------
class OverState extends AbstractState {
	private var s:DisplayObject;

	public function OverState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
		if (Object(this).constructor == OverState) {
			if (!s) s = RootProvider.getStageOrRoot();
			s.addEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove, false, 0, true);
		}
	}

	override public function out():void {
		button.ns::setState(new OutState(button, ns));
	}

	override public function press():void {
		button.ns::setState(new PressedState(button, ns));
	}

	override public function callImplementation():void {
		if (!(button.ns::previousState is OverState)) {
			button.ns::doOver_ns();
		}
	}

	override public function dispose():void {
		if (s) s.removeEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove);
		super.dispose();
	}

	private function onStage_MouseMove(event:MouseEvent):void {
		if (isDisposed) {
			event.target.removeEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove);
		} else {
			button.ns::doMouseMoveOver_ns();
		}
	}
}
// ------------------------------------------------------------------------------
class DisabledState extends AbstractState {
	public function DisabledState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
	}

	override public function callImplementation():void {
		if (!(button.ns::previousState is OutState)) {
			button.ns::doOut_ns();
		}
		if (button) {
			button.ns::doDisabled_ns();
		}
	}
}
// ------------------------------------------------------------------------------
class OverFreezeState extends DisabledState {
	public function OverFreezeState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
	}

	override public function callImplementation():void {
		if (!(button.ns::previousState is OverState)) {
			button.ns::doOver_ns();
		}
		button.ns::doFreeze_ns();
	}

	override public function dispose():void {
		button.ns::doUnfreeze_ns();
		super.dispose();
	}
}
// ------------------------------------------------------------------------------
class PressedState extends OverState {
	private var s:DisplayObject;

	public function PressedState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
		s = RootProvider.getStageOrRoot()
		s.addEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove, false, 0, true);
	}

	override public function release():void {
		button.ns::doReleaseOver_ns();
		button.ns::doRelease_ns();
		if (ButtonModel.touchMode) {
			if (button) button.ns::setState(new OutState(button, ns));
		} else {
			if (button) button.ns::setState(new OverState(button, ns));
		}
	}

	override public function out():void {
		button.ns::doDragOut_ns();
		button.ns::setState(new PressedOutsideState(button, ns));
	}

	override public function overFreeze():void {
		button.ns::doRelease_ns();
		button.ns::setState(new OverFreezeState(button, ns));
	}

	override public function callImplementation():void {
		if (!(button.ns::previousState is PressedState)) {
			button.ns::doPress_ns();
		}
	}

	override public function dispose():void {
		s.removeEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove);
		super.dispose();
	}

	// ----------------------------------------------------------------------
	// event handlers
	// ----------------------------------------------------------------------
	private function onStage_MouseMove(event:MouseEvent):void {
		if (!button) {
			IEventDispatcher(event.target).removeEventListener(event.type, onStage_MouseMove)
			return;
		}
		button.ns::doDragMove_ns();
	}
}
// ------------------------------------------------------------------------------
class PressedOutsideState extends PressedState {
	public function PressedOutsideState(buttonModel:ButtonModel, ns:Namespace) {
		super(buttonModel, ns);
	}

	override public function release():void {
		button.ns::doReleaseOutside_ns();
		button.ns::doRelease_ns();
		if (ButtonModel.touchMode) {
			if (button) button.ns::setState(new OutState(button, ns));
		}else{
			button.ns::setState(new OutState(button, ns));
		}
	}

	override public function over():void {
		button.ns::doDragOver_ns();
		button.ns::setState(new PressedState(button, ns));
	}

	override public function overFreeze():void {
		button.ns::doRelease_ns();
		button.ns::setState(new OverFreezeState(button, ns));
	}
}