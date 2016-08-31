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
package pl.brun.lib.actions {
	import pl.brun.lib.Base;

	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	[Event(name="runningStart", type="pl.brun.lib.actions.ActionEvent")]
	[Event(name="runningMiddleEnter", type="pl.brun.lib.actions.ActionEvent")]
	[Event(name="childActionRunningStart", type="pl.brun.lib.actions.ChildActionEvent")]
	[Event(name="targetPatchComplete", type="pl.brun.lib.actions.ActionEvent")]
	[Event(name="childActionRunningFinish", type="pl.brun.lib.actions.ChildActionEvent")]
	[Event(name="runningMiddleOut", type="pl.brun.lib.actions.ActionEvent")]
	[Event(name="runningFinish", type="pl.brun.lib.actions.ActionEvent")]
	[Event(name="runningFlagChanged", type="pl.brun.lib.actions.ActionEvent")]
	/**
	 * <pre> Abstract class.
	 * 
	 * Action class offers complex implementation of running/idle state.
	 * 
	 * 
	 * The rules of actions:
	 * 	- With every calling of start/finish you can be sure only that you change
	 * 	the runningFlag (Boolean) of action (true with start, false with finish) 
	 *  - Calling the start/finish of action dosent meant that that action will
	 *  start/finish. Action can block its running/finish by itself, and after some
	 *  preparation is done, trigger its running/finish by itself (if runningFlag
	 *  dosent change in the mean time).
	 *  - Each action can have its parent action, and children actions. This means
	 *  that if my parent action is not running, and my start() method is triggered,
	 *  then parent action start is triggered instead. If parent action is finally
	 *  running, and child action have runningFlag still at true, then the child action
	 *  is started by the parent action.
	 *  - Opposite with the finishing of running - parent action can't be finished
	 *  until child action will be finished. After finish of child action, parent
	 *  action is starting to finish (if runningFlag is still at false).
	 * 
	 * 
	 * Please check abstract methods to see specicic features.
	 * 
	 * Also check following tests for a better understanding of "actions" concept:
	 *  - pl.brun.lib.test.actions.ActionClassTest
	 *  - pl.brun.lib.test.actions.ActionClassTargetPatchTest
	 *  - pl.brun.lib.test.actions.ActionsQueueClassTest
	 *  - pl.brun.lib.test.actions.MCPlayToIniMidEndClassTest
	 * 
	 * 
	 * All abstract methods are optional. They arrange in code describe life cycle
	 * of action (from top (start) to down (finish)).
	 * 
	 * 
	 * Commenting guide:
	 * 
	 * To specify how to deal with start/finish of action (possible options):
	 * Start - external (can be started only from outside)
	 * Start - internal (can be started only by itself)
	 * Start - external and internal (can be started from outside and by itself)
	 * Finish - external (can be finished only from outside)
	 * Finish - internal (can be finished only by itself)
	 * Finish - external and internal (can be finished from outside and by itself)
	 * 
	 * To specify what is going on while running/idle:
	 * Running - (running state description)
	 * Idle - (idle state description)
	 * 
	 * 
	 * Events:
	 *  - ActionEvent.RUNNING_START
	 *  - ActionEvent.RUNNING_MID_ENTER
	 *  - ChildActionEvent.CHILD_ACTION_RUNNING_START
	 *  - ActionEvent.TARGET_PATCH_COMPLETE
	 *  - ChildActionEvent.CHILD_ACTION_RUNNING_FINISH
	 *  - ActionEvent.RUNNING_MID_OUT
	 *  - ActionEvent.RUNNING_FINISH
	 *  - ActionEvent.RUNNING_FLAG_CHANGED
	 *  - ActionEvent.RUNNING_STATE_CHANGED
	 * 
	 * @author Marek Brun
	 */
	public class Action extends Base {
		private var isDisposing:Boolean;
		protected var canBeFinishedBool:Boolean = true;
		private namespace state;
		use namespace state;
		private var currentState:AbstractState;
		private var idleState:IdleState;
		private var runningState:RunningState;
		private var runningInitialState:RunningInitialState;
		private var runningMiddleState:RunningMiddleState;
		private var runningChildState:RunningChildState;
		private var runningPatchChildState:RunningPatchChildState;
		private var runningEndingState:RunningEndingState;
		private var _parent:Action;
		/** true - this instace "should be" running */
		private var isRunningFlag_:Boolean;
		/**
		 * Before action is finished you can mark this run as successful.
		 * It dosent apply in any way to how action will work.
		 */
		private var _isSuccess:Boolean;
		/** Used for example by ActionsQueue to prevent start out of queue order. */
		public var isStartBlocked:Boolean;
		public var startsCount:uint;
		public var isEndingActionStarted:Boolean;
		public var childActions:Array /*of Action*/ 
		= [];
		public var isMiddleNoChildActionRunning:Boolean;
		public var targetPatch:Array /*of String*/;

		public function Action() {
			setState(getIdleState());
		}

		public function switchRunning():void {
			isRunningFlag ? finish() : start()
		}

		protected function getStateNamespace():Namespace {
			return state;
		}

		/*abstract*/
		/**
		 * Asking for agree to start.
		 * 
		 * If your implmentation can't be started actually - return false
		 * In such case "prepareToStart()" will be called.
		 * After class is finally ready to start please call "readyToStart()".
		 */
		protected function canBeStarted():Boolean {
			/*
			In case implementation-overriding-implementation:
			if(super.canBeStarted()){
			return <my running start check>;
			}
			return false;
			 */
			return true;
		}

		/*abstract*/
		/**
		 * Called when "canBeStarted" returns false (start is internally blocked)
		 */
		protected function prepareToStart():void {
			/*
			In case implementation-overriding-implementation:
			super.prepareToStart();
			 */
		}

		/*abstract*/
		/**
		 * Class is just successfully started.
		 * This is the place to do some initialization. 
		 */
		protected function doRunning():void {
			/*
			In case implementation-overriding-implementation:
			super.doRunning();
			<my running start>;
			 */
		}

		/*abstract*/
		/**
		 * Place to pass intialization action (between start and middle state).
		 */
		protected function getInitialAction():Action {
			return null;
		}

		/*abstract*/
		/**
		 * If there was initial action - is is finished.
		 * Action running is fully initialised.
		 */
		protected function doMiddleEnter():void {
			/*
			In case implementation-overriding-implementation:
			super.doMiddleEnter();
			<my middle enter>;
			 */
		}

		/*abstract*/
		/**
		 * Action is entered state with fully runing, but with no child
		 * action running.
		 */
		protected function doMiddleNoChildActionRunningEnter(childPreparedToRun:Action = null):void {
			/*
			In case implementation-overriding-implementation:
			super.doMiddleNoChildActionRunningEnter();
			<my middle no child action running>;
			 */
		}

		/*abstract*/
		/**
		 * Action was in state state with fully runing, but with no child
		 * action running. But now things changed and some child action 
		 * is started runnig.
		 */
		protected function doMiddleNoChildActionRunningOut():void {
			/*
			In case implementation-overriding-implementation:
			super.doMiddleNoChildActionRunningOut();
			<my middle no child action running>;
			 */
		}

		/*abstract*/
		/**
		 * Some child action is stared running.
		 */
		protected function doChildActionStartRunning(childAction:Action):void {
			/*
			In case implementation-overriding-implementation:
			super.doMiddleChildActionStartRunning();
			<my middle child action start running>;
			 */
		}

		/*abstract*/
		/**
		 * Some child action is finished running.
		 */
		protected function doChildActionFinishRunning(childAction:Action):void {
			/*
			In case implementation-overriding-implementation:
			super.doMiddleChildActionFinishRunning();
			<my middle child action finish running>;
			 */
		}

		/*abstract*/
		/**
		 * Action is starting to finish - so we go out of the middle state.
		 */
		protected function doMiddleOut():void {
			/*  
			In case implementation-overriding-implementation:
			<my middle out>;
			super.doMiddleOut();
			 */
		}

		/*abstract*/
		/**
		 * Place to pass ending action.
		 */
		protected function getEndingAction():Action {
			return null;
		}

		/*abstract*/
		/**
		 * Asking for agree to finish.
		 * 
		 * If this class can't be actually finished - return false (in implmentation)
		 * In such case "prepareToFinish()" will be called.
		 * After class is finally ready to finish please call "readyToFinish()".
		 */
		protected function canBeFinished():Boolean {
			/*  
			In case implementation-overriding-implementation:
			if(super.canBeFinished()){
			return <my finish check>;
			}
			return false;
			 */
			return canBeFinishedBool;
		}

		/*abstract*/
		/**
		 * Called when "canBeFinished" returns false
		 */
		protected function prepareToFinish():void {
			/*
			In case implementation-overriding-implementation:
			super.prepareToFinish();
			 */
		}

		/*abstract*/
		/**
		 * Class is fully finished - entered "idle" state
		 */
		protected function doIdle():void {
			/*
			In case implementation-overriding-implementation:
			super.doIdle();
			<my idle start>;
			 */
		}

		/*abstract*/
		/**
		 * If this class is one-time-use class - please return false. 
		 */
		protected function canBeRestarted():Boolean {
			/*  
			In case implementation-overriding-implementation:
			if(super.canBeRestarted()){
			return <my restart check>;
			}
			return true;
			 */
			return true;
		}

		/*abstract*/
		/**
		 * If canBeRestarted() returns false and isDisposeAfterFinishWithNoRestart()
		 * is returns true, then instance will be disposed after finish occurs.
		 */
		protected function isDisposeAfterFinishWithNoRestart():Boolean {
			return false;
		}

		/*abstract*/
		/**
		 * Place to handle running flag change.
		 */
		protected function doAfterRunningFlagChanged():void {
			/*
			In case implementation-overriding-implementation:
			super.doAfterRunningFlagChanged();
			<my running start>;
			 */
		}

		/*abstract*/
		/**
		 * When you setup target patch by calling <code>setTargetPatch</code>
		 * and action is running - this is the place to pass action created
		 * by string. It can be new action or already created action.
		 * 
		 * Created action will become child action of this instance and
		 * will be started.
		 * 
		 */
		protected function getActionByPatchName(patchName:String):Action {
			/*
			In case implementation-overriding-implementation:
			switch(patchName){
			case <some patch name>:
			return <action creation by patch name>
			break;
			}
			super.getActionByPatchName(patchName);
			 */
			throw IllegalOperationError("Can't create action by patchName:\"" + patchName + '"');
			return null;
		}

		/*abstract*/
		/**
		 * Called when there's:
		 *  - requested the same patch as current
		 *  - currently running child action created by patch
		 *  - requested patch got one string (patch array length is 1)
		 * 
		 * In other words - when requested patch is already running.
		 * 
		 */
		protected function doEndPatchRepeat(patchName:String):void {
		}

		/*abstract*/
		protected function doStateChanged():void {
		}

		public function getChildActions():Array {
			return childActions.concat()
		}

		// --------------------------------------------------------------------------
		// end of abstract methods
		// --------------------------------------------------------------------------
		public function canBeStarted_ns():Boolean {
			return canBeStarted();
		}

		public function getActionByPatchName_ns(patchName:String):Action {
			return getActionByPatchName(patchName);
		}

		public function doEndPatchRepeat_ns(patchName:String):void {
			doEndPatchRepeat(patchName);
		}

		public function prepareToStart_ns():void {
			prepareToStart();
		}

		public function doRunning_ns():void {
			doRunning();
		}

		public function canBeRestarted_ns():Boolean {
			return canBeRestarted();
		}

		public function getInitialAction_ns():Action {
			return getInitialAction();
		}

		public function doMiddleEnter_ns():void {
			dispatchEvent(new ActionEvent(ActionEvent.RUNNING_MIDDLE_ENTER));
			doMiddleEnter();
		}

		public function doMiddleNoChildActionRunningEnter_ns(childPreparedToRun:Action = null):void {
			if (!isMiddleNoChildActionRunning) {
				isMiddleNoChildActionRunning = true;
				doMiddleNoChildActionRunningEnter(childPreparedToRun);
			}
		}

		public function doMiddleNoChildActionRunningOut_ns():void {
			if (isMiddleNoChildActionRunning) {
				isMiddleNoChildActionRunning = false;
				doMiddleNoChildActionRunningOut();
			}
		}

		public function doChildActionStartRunning_ns(childAction:Action):void {
			doMiddleNoChildActionRunningOut_ns();
			doChildActionStartRunning(childAction);
			dispatchChildActionRunningStart(this, childAction);
		}

		private function dispatchChildActionRunningStart(childParent:Action, child:Action):void {
			dispatchEvent(new ChildActionEvent(ChildActionEvent.CHILD_ACTION_RUNNING_START, childParent, child));
			if (parent) {
				parent.dispatchChildActionRunningStart(childParent, child);
			}
		}

		public function doChildActionFinishRunning_ns(childAction:Action):void {
			doChildActionFinishRunning(childAction);
			dispatchChildActionRunningFinish(this, childAction);
		}

		private function dispatchChildActionRunningFinish(childParent:Action, child:Action):void {
			dispatchEvent(new ChildActionEvent(ChildActionEvent.CHILD_ACTION_RUNNING_FINISH, childParent, child));
			if (parent) {
				parent.dispatchChildActionRunningFinish(childParent, child);
			}
		}

		public function doMiddleOut_ns():void {
			doMiddleNoChildActionRunningOut_ns();
			doMiddleOut();
			dispatchEvent(new ActionEvent(ActionEvent.RUNNING_MIDDLE_OUT));
		}

		public function getEndingAction_ns():Action {
			return getEndingAction();
		}

		public function prepareToFinish_ns():void {
			prepareToFinish();
		}

		public function canBeFinished_ns():Boolean {
			return canBeFinished();
		}

		public function doIdle_ns():void {
			doIdle();
		}

		public function isDisposeAfterFinishWithNoRestart_ns():Boolean {
			return isDisposeAfterFinishWithNoRestart();
		}

		public function getCurrentRunningChild():Action {
			if (currentState is RunningChildState) {
				return RunningChildState(currentState).runningChildAction;
			}
			return null;
		}

		public function gotAnyChildToRun():Boolean {
			var children:Array = getChildActions()
			for each (var child:Action in children) {
				if (child.isRunning || child.isRunningFlag) return true;
			}
			return false
		}

		final protected function readyToStart():void {
			if (isRunningFlag) {
				start();
			}
		}

		final protected function readyToFinish():void {
			if (!isRunningFlag) {
				finish();
			}
		}

		public function set isRunningFlag(value:Boolean):void {
			if (isRunningFlag_ == value) {
				return;
			}
			isRunningFlag_ = value;
			if (isRunningFlag_) {
				setParentRunningFlag();
			}
			doAfterRunningFlagChanged();
			dispatchEvent(new ActionEvent(ActionEvent.RUNNING_FLAG_CHANGED));
		}

		protected function setParentRunningFlag():void {
			if (!parent) {
				return;
			}
			parent.isRunningFlag = true;
			parent.setParentRunningFlag();
		}

		final public function addChildAction(action:Action):void {
			action.parent = this;
		}

		private function removeChildAction(action:Action):void {
			action.parent = null;
		}

		public function get isRunningFlag():Boolean {
			return isRunningFlag_;
		}

		public function set parent(value:Action):void {
			if (_parent == value) {
				// passed parent is already parent for that instance
				return;
			}
			if (isRunning && !isDisposing) {
				if (value) {
					throw new ArgumentError("Parent-Action can't be set while running.");
				}
				throw new ArgumentError("Parent-Action can't be removed while running.");
			}
			if (_parent) {
				if (!_parent.isDisposed) {
					_parent.unregisterChildAction(this);
				}
				_parent = null;
			}
			if (value) {
				_parent = value;
				_parent.registerChildAction(this);
			}
		}

		public function get parent():Action {
			return _parent;
		}

		private function registerChildAction(action:Action):void {
			childActions.push(action);
		}

		private function unregisterChildAction(action:Action):void {
			childActions.splice(childActions.indexOf(action), 1);
		}

		public function start():Boolean {
			if (isDisposed) return false;
			isRunningFlag = true;
			return currentState.start();
		}

		public function finish():Boolean {
			if (isDisposed) return true;
			isRunningFlag = false;
			return currentState.finish();
		}

		public function setIsRunning(running:Boolean):void {
			if (isRunning != running) {
				if (running) {
					start()
				} else {
					finish()
				}
			}
		}

		final public function setTargetPatch(targetPatchNames:Array/*of String*/):void {
			this.targetPatch = targetPatchNames;
			currentState.applyTargetPatch();
		}

		final public function getCurrentPatch():Array/*of String*/
 		{
			var patch:Array = [];
			if (currentState is RunningPatchChildState) {
				patch = [RunningPatchChildState(currentState).patch[0]];
				if (getCurrentRunningChild().currentState is RunningPatchChildState) {
					return patch.concat(getCurrentRunningChild().getCurrentPatch());
				}
			}
			return patch;
		}

		public function dispatchTargetPatchCompleteEvent():void {
			dispatchEvent(new ActionEvent(ActionEvent.TARGET_PATCH_COMPLETE));
			if (parent && parent.currentState is RunningPatchChildState) {
				parent.dispatchTargetPatchCompleteEvent();
			}
		}

		public function get isSuccess():Boolean {
			return _isSuccess;
		}

		protected function markAsSuccessAction():void {
			_isSuccess = true;
		}

		public function onStart():void {
			_isSuccess = false;
		}

		final public function isInMidState():Boolean {
			return getState() is RunningMiddleState || getState() is RunningChildState;
		}

		final public function get isRunning():Boolean {
			return currentState is RunningState;
		}

		final public function set isRunning(value:Boolean):void {
			if (value) {
				start()
			} else {
				finish()
			}
		}

		public function setState(state:AbstractState):void {
			if (currentState == state) {
				return;
			}
			currentState = state;
			doStateChanged();
		}

		public function getState():AbstractState {
			return currentState;
		}

		public function getRunningState():RunningState {
			if (!runningState) {
				runningState = new RunningState(this, state);
			}
			return runningState;
		}

		public function getRunningInitialState():RunningInitialState {
			if (!runningInitialState) {
				runningInitialState = new RunningInitialState(this, state);
			}
			return runningInitialState;
		}

		public function getRunningMiddleState():RunningMiddleState {
			if (!runningMiddleState) {
				runningMiddleState = new RunningMiddleState(this, state);
			}
			return runningMiddleState;
		}

		public function getRunningEndingState():RunningEndingState {
			if (!runningEndingState) {
				runningEndingState = new RunningEndingState(this, state);
			}
			return runningEndingState;
		}

		public function getIdleState():IdleState {
			if (!idleState) {
				idleState = new IdleState(this, state);
			}
			return idleState;
		}

		public function getRunningChildState():RunningChildState {
			if (!runningChildState) {
				runningChildState = new RunningChildState(this, state);
			}
			return runningChildState;
		}

		public function getRunningPatchChildState():RunningPatchChildState {
			if (!runningPatchChildState) {
				runningPatchChildState = new RunningPatchChildState(this, state);
			}
			return runningPatchChildState;
		}

		public function getStateName():String {
			return getQualifiedClassName(getState()).split('::')[1];
		}

		override public function dispose():void {
			isDisposing = true;
			if (parent) {
				parent.removeChildAction(this);
			}

			if (isRunning) {
				setState(getIdleState())
				dispatchEvent(new ActionEvent(ActionEvent.RUNNING_FINISH));
			}
			if (runningState) {
				runningState.dispose();
				runningState = null;
			}
			if (runningInitialState) {
				runningInitialState.dispose();
				runningInitialState = null;
			}
			if (runningMiddleState) {
				runningMiddleState.dispose();
				runningMiddleState = null;
			}
			if (runningEndingState) {
				runningEndingState.dispose();
				runningEndingState = null;
			}
			if (idleState) {
				idleState.dispose();
				idleState = null;
			}
			if (runningChildState) {
				runningChildState.dispose();
				runningChildState = null;
			}
			if (runningPatchChildState) {
				runningPatchChildState.dispose();
				runningPatchChildState = null;
			}

			super.dispose();
			childActions = null;
		}
	}
}
import pl.brun.lib.actions.Action;
import pl.brun.lib.actions.ActionEvent;

import flash.errors.IllegalOperationError;
import flash.events.Event;

class AbstractState {
	protected var action:Action;
	protected var ns:Namespace;

	public function AbstractState(action:Action, ns:Namespace) {
		this.action = action;
		this.ns = ns;
	}

	/*abstract*/
	public function start():Boolean {
		return false;
	}

	/*abstract*/
	public function finish():Boolean {
		return false;
	}

	/*abstract*/
	public function applyTargetPatch():void {
	}

	public function dispose():void {
		action = null;
	}

	public function tryStartChildAction(childAction:Action):void {
		var i:uint;
		for (i = 0;i < action.childActions.length;i++) {
			action.childActions[i].isRunningFlag = action.childActions[i] == childAction;
		}
	}
}
// --------------------------------------------------------------------------
// just running (no initial, ending or child action is running)
// --------------------------------------------------------------------------
class RunningState extends AbstractState {
	private var isPrepareToFinishNow:Boolean;
	private var isTryFinishAfterPrepare:Boolean;

	public function RunningState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	public function doActionStart():void {
		action.isEndingActionStarted = false;

		// incrementation of value unnder namespace bug
		action.startsCount = action.startsCount + 1;

		var initialAction:Action = action.getInitialAction_ns();
		if (initialAction) {
			action.setState(action.getRunningInitialState());
		} else {
			action.setState(action.getRunningState());
		}
		action.doRunning_ns();
		action.dispatchEvent(new ActionEvent(ActionEvent.RUNNING_START));

		if (initialAction) {
			action.getRunningInitialState().startInitialAction(initialAction);
		} else {
			action.getRunningState().tryMiddleEnter();
		}
	}

	override public function finish():Boolean {
		if (isPrepareToFinishNow) {
			isTryFinishAfterPrepare = true
			return false;
		}

		var endingAction:Action;
		if (!action.isEndingActionStarted) {
			endingAction = action.getEndingAction_ns();
		}
		if (endingAction) {
			action.isEndingActionStarted = true;
			action.setState(action.getRunningEndingState());
			action.getRunningEndingState().startEndingAction(endingAction);
			return false;
		}

		if (!action.canBeFinished_ns()) {
			isPrepareToFinishNow = true
			isTryFinishAfterPrepare = false
			action.prepareToFinish_ns();
			isPrepareToFinishNow = false
			if (isTryFinishAfterPrepare) {
				// looks like prepareToFinish was quite instant
				// so we proceed - no return
				isTryFinishAfterPrepare = false
			} else {
				isTryFinishAfterPrepare = false
				return false;
			}
		}

		action.setState(action.getIdleState());
		action.doIdle_ns();
		var actionTmp:Action = action;
		action.dispatchEvent(new ActionEvent(ActionEvent.RUNNING_FINISH));

		if (!actionTmp.isDisposed && action.isDisposeAfterFinishWithNoRestart_ns() && !action.canBeRestarted_ns() && !action.isDisposed) {
			action.dispose();
		}
		return true;
	}

	public function tryMiddleEnter():void {
		if (action.isRunningFlag) {
			action.setState(action.getRunningMiddleState());
			action.getRunningMiddleState().doEnterFromRunningState();
		} else {
			finish();
		}
	}

	public function doAfterEndingActionFinish():void {
		if (action.isRunningFlag) {
			// if runnig flag is true just before finish then
			// action is not finish but started again - loopped
			doActionStart();
		} else {
			finish();
		}
	}
}
// --------------------------------------------------------------------------
// initial action is running
// --------------------------------------------------------------------------
class RunningInitialState extends RunningState {
	private var initialAction:Action;

	public function RunningInitialState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	/**
	 * Initial action can't be forced to finish - it must finish itself.
	 */
	override public function finish():Boolean {
		return false;
	}

	public function startInitialAction(initialAction:Action):void {
		this.initialAction = initialAction;
		initialAction.addEventListener(ActionEvent.RUNNING_FINISH, onInitialAction_RunningFinish);
		initialAction.start();
	}

	override public function dispose():void {
		if (initialAction) {
			initialAction.removeEventListener(ActionEvent.RUNNING_FINISH, onInitialAction_RunningFinish);
		}
		initialAction = null;
		super.dispose();
	}

	// --------------------------------------------------------------------------
	// handlers
	// --------------------------------------------------------------------------
	private function onInitialAction_RunningFinish(event:Event):void {
		if (event.target != initialAction) {
			throw new IllegalOperationError('Unexpected event target');
		}
		initialAction.removeEventListener(ActionEvent.RUNNING_FINISH, onInitialAction_RunningFinish);
		initialAction = null;
		action.setState(action.getRunningState());
		action.getRunningState().tryMiddleEnter();
	}
}
// --------------------------------------------------------------------------
// middle
// --------------------------------------------------------------------------
class RunningMiddleState extends RunningState {
	public var childActionToRun:Action;
	private var patchOfChildActionToRun:Array/*of String*/;
	public var isEnteringState:Boolean;
	private var isChildActionToRun_start_now:Boolean;

	public function RunningMiddleState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	override public function finish():Boolean {
		if (childActionToRun) {
			// there was unstarted child action to run
			// but since this action is planning to finish we
			// block auto start of that child action
			childActionToRun.isRunningFlag = false;
			disposeChildActionToRun();
		}
		return super.finish();
	}

	protected function getChildActionWithRunningFlag():Action {
		var i:uint;
		var childAction:Action;
		for (i = 0;i < action.childActions.length;i++) {
			if (action.childActions[i].isRunning) {
				throw new IllegalOperationError('Child action is running without parent permission (o rly? (; )');
			}
			if (action.childActions[i].isRunningFlag) {
				childAction = action.childActions[i];
				break;
			}
		}
		return childAction;
	}

	private function tryStartChild():Boolean {
		if (action.targetPatch && action.targetPatch.length) {
			// first we check if there's some child action from target patch to start
			if (!(childActionToRun && patchOfChildActionToRun && patchOfChildActionToRun[0] == action.targetPatch[0])) {
				childActionToRun = action.getActionByPatchName_ns(action.targetPatch[0]);
			}
			patchOfChildActionToRun = action.targetPatch;

			// setting "this" action as parent of action returned by implmementation
			// so it can't be action that is currently running
			childActionToRun.parent = action;
			childActionToRun.addEventListener(ActionEvent.RUNNING_START, onPatchChildActionToRun_RunningStart);
			isChildActionToRun_start_now = true
			childActionToRun.start()
			isChildActionToRun_start_now = false

			return true;
		} else {
			// ok, no patch, so maybe there's some child that "want" to start?
			childActionToRun = getChildActionWithRunningFlag();
			if (childActionToRun) {
				// yup, there's one!
				childActionToRun.addEventListener(ActionEvent.RUNNING_START, onChildActionToRun_RunningStart);
				isChildActionToRun_start_now = true
				childActionToRun.start();
				isChildActionToRun_start_now = false
				return true;
			}
		}

		return false;
	}

	public function doEnterFromRunningState():void {
		isEnteringState = true;
		action.doMiddleEnter_ns();
		isEnteringState = false;
		action.getRunningMiddleState().decideAboutNextWhileMiddle();
	}

	public function decideAboutNextWhileMiddle():void {
		if (!action.isRunningFlag) {
			finish();
			return;
		}
		tryStartChild();
		if (action.getState() == this) {
			// finally - no child started, so we just "idle" at the middle state
			// (maybe waiting for child action to start)
			action.doMiddleNoChildActionRunningEnter_ns(childActionToRun);
		}
	}

	override public function tryStartChildAction(childAction:Action):void {
		if (isChildActionToRun_start_now) {
			throw new IllegalOperationError("Can't start child action while other sibling action is executing doRunning. Wait one frame and then start other action.")
			return;
		}
		if (childActionToRun == childAction) {
			return;
		} else if (childActionToRun) {
			disposeChildActionToRun();
		}
		super.tryStartChildAction(childAction);
		decideAboutNextWhileMiddle();
	}

	override public function applyTargetPatch():void {
		if (isEnteringState) {
			return;
		}
		tryStartChild();
	}

	private function disposeChildActionToRun():void {
		if (childActionToRun) {
			childActionToRun.removeEventListener(ActionEvent.RUNNING_START, onPatchChildActionToRun_RunningStart);
			childActionToRun.removeEventListener(ActionEvent.RUNNING_START, onChildActionToRun_RunningStart);
			childActionToRun = null;
		}
	}

	override public function dispose():void {
		disposeChildActionToRun();
		super.dispose();
	}

	// --------------------------------------------------------------------------
	// handlers
	// --------------------------------------------------------------------------
	private function onChildActionToRun_RunningStart(event:Event):void {
		if (event.target != childActionToRun) {
			throw new IllegalOperationError('Unexpected event target');
		}
		var tmp:Action = childActionToRun;
		disposeChildActionToRun();
		action.setState(action.getRunningChildState());
		action.getRunningChildState().childStartedRunning(tmp);
	}

	private function onPatchChildActionToRun_RunningStart(event:Event):void {
		if (event.target != childActionToRun) {
			throw new IllegalOperationError('Unexpected event target');
		}
		var tmp:Action = childActionToRun;
		disposeChildActionToRun();

		action.setState(action.getRunningPatchChildState());
		action.getRunningPatchChildState().patchChildStartedRunning(tmp, patchOfChildActionToRun);
	}
}
// --------------------------------------------------------------------------
// child action is running now
// --------------------------------------------------------------------------
class RunningChildState extends RunningMiddleState {
	public var runningChildAction:Action;

	public function RunningChildState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	override public function finish():Boolean {
		runningChildAction.removeEventListener(ActionEvent.RUNNING_FINISH, onChildAction_RunningFinish);
		if (!runningChildAction.isRunning || runningChildAction.finish()) {
			action.setState(action.getRunningState());
			return action.finish();
		}
		runningChildAction.addEventListener(ActionEvent.RUNNING_FINISH, onChildAction_RunningFinish);
		return false;
	}

	public function childStartedRunning(childAction:Action):void {
		if (!childAction.isRunning) {
			throw new IllegalOperationError("Child action is supposed to run now, but it's not");
		}
		runningChildAction = childAction;
		action.doChildActionStartRunning_ns(runningChildAction);
		runningChildAction.addEventListener(ActionEvent.RUNNING_FINISH, onChildAction_RunningFinish);
	}

	override public function tryStartChildAction(childAction:Action):void {
		var i:uint;
		for (i = 0;i < action.childActions.length;i++) {
			action.childActions[i].isRunningFlag = action.childActions[i] == childAction;
		}
		runningChildAction.finish();
	}

	/**
	 * This child action is not an a patch child, so the first thing to do is finish it.
	 */
	override public function applyTargetPatch():void {
		runningChildAction.finish();
	}

	override public function dispose():void {
		if (runningChildAction) {
			runningChildAction.removeEventListener(ActionEvent.RUNNING_FINISH, onChildAction_RunningFinish);
		}
		runningChildAction = null;
		super.dispose();
	}

	// --------------------------------------------------------------------------
	// handlers
	// --------------------------------------------------------------------------
	private function onChildAction_RunningFinish(event:Event):void {
		if(!action) return;
		if (event.target != runningChildAction) {
			throw new IllegalOperationError('Unexpected event target');
		}
		action.doChildActionFinishRunning_ns(runningChildAction);
		if(!action) return;
		runningChildAction.removeEventListener(ActionEvent.RUNNING_FINISH, onChildAction_RunningFinish);
		runningChildAction = null;
		action.setState(action.getRunningMiddleState());
		action.getRunningMiddleState().decideAboutNextWhileMiddle();
	}
}
// --------------------------------------------------------------------------
// child action created by patch is running now
// --------------------------------------------------------------------------
class RunningPatchChildState extends RunningChildState {
	public var patch:Array/*of String*/;

	public function RunningPatchChildState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	public function patchChildStartedRunning(childAction:Action, patch:Array/*of String*/):void {
		this.patch = patch;
		childStartedRunning(childAction);
		var childActionPatch:Array = patch.concat();
		childActionPatch.shift();
		if (!childActionPatch.length) {
			action.dispatchTargetPatchCompleteEvent();
		}
		childAction.setTargetPatch(childActionPatch);
	}

	override public function applyTargetPatch():void {
		if (action.targetPatch[0] == patch[0]) {
			if (action.targetPatch.length == 1 && patch.length == 1) {
				action.doEndPatchRepeat_ns(patch[0]);
			} else {
				var childActionPatch:Array = action.targetPatch.concat();
				childActionPatch.shift();
				runningChildAction.setTargetPatch(childActionPatch);
			}
		} else {
			super.applyTargetPatch();
		}
	}
}
// --------------------------------------------------------------------------
// ending action is running
// --------------------------------------------------------------------------
class RunningEndingState extends RunningState {
	private var endingAction:Action;

	public function RunningEndingState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	/**
	 * Ending action can't be forced to finish - it must finish itself.
	 */
	override public function finish():Boolean {
		return false;
	}

	public function startEndingAction(endingAction:Action):void {
		action.doMiddleOut_ns();
		this.endingAction = endingAction;
		endingAction.addEventListener(ActionEvent.RUNNING_FINISH, onEndingAction_RunningFinish);
		endingAction.start();
	}

	override public function dispose():void {
		if (endingAction) {
			endingAction.addEventListener(ActionEvent.RUNNING_FINISH, onEndingAction_RunningFinish);
		}
		endingAction = null;
		super.dispose();
	}

	// --------------------------------------------------------------------------
	// handlers
	// --------------------------------------------------------------------------
	private function onEndingAction_RunningFinish(event:Event):void {
		if (event.target != endingAction) {
			throw new IllegalOperationError('Unexpected event target');
		}
		endingAction.removeEventListener(ActionEvent.RUNNING_FINISH, onEndingAction_RunningFinish);
		action.setState(action.getRunningState());
		action.getRunningState().doAfterEndingActionFinish();
	}
}
// --------------------------------------------------------------------------
// idle (isRunning() - false)
// --------------------------------------------------------------------------
class IdleState extends AbstractState {
	public function IdleState(action:Action, ns:Namespace) {
		super(action, ns);
	}

	override public function start():Boolean {
		// maybe action is blocked by some other class, for ex. ActionsQueue
		if (action.isStartBlocked) {
			return false;
		}

		// action was started once before, and canBeRestarted() return false
		// so this action cant be started
		if (action.startsCount > 0 && !action.canBeRestarted_ns()) {
			throw new IllegalOperationError("This instance can't be restarted (blocked by author).");
		}

		if (action.parent) {
			if (Object(action.parent.getState()).constructor == RunningMiddleState && RunningMiddleState(action.parent.getState()).isEnteringState) {
				// parent is executing doEnterMid now - can't start yet
				return false;
			}
			// special condition to prevent infinite loop recurention, when parent
			// is starting child action
			if (!(Object(action.parent.getState()).constructor == RunningMiddleState && RunningMiddleState(action.parent.getState()).childActionToRun == action)) {
				// ok, so parent is not trying start us now, so we start us by the parent
				action.parent.getState().tryStartChildAction(action);
				return false;
			}
		}

		var canBeStarted:Boolean = action.canBeStarted_ns();

		if (!canBeStarted) {
			// implementation don't allow for start itself
			// maybe there's some preparation needed to be done?
			action.prepareToStart_ns();
			return false;
		}

		// ok, ready for start
		action.onStart()
		action.setState(action.getRunningState());
		action.getRunningState().doActionStart();
		return true;
	}

	override public function applyTargetPatch():void {
		action.start();
	}

	override public function tryStartChildAction(childAction:Action):void {
		super.tryStartChildAction(childAction);
		action.start();
	}
}
