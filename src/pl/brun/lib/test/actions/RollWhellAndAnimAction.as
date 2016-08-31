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
package pl.brun.lib.test.actions {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.display.actions.MCPlayForwardFromToAction;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.display.button.views.ContrastButtonView;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	/**
	 * @author Marek Brun
	 */
	public class RollWhellAndAnimAction extends Action {

		public var isSelfFinish:Boolean;
		private var mc_flag:MovieClip /*0.7,-21.05(0.7,-21.05) 11.8x10.55 frames:2*/;
		private var mc_circle:MovieClip /*5.4,-2.1(0.7,-6.8) 9.4x9.4 frames:16*/;
		private var mc_tf:TextField /*2,2(0,0) 12.35x17.25*/;
		private var mc_tfState:TextField /*14.25,2(12.25,0) 12.35x17.25*/;
		private var mc_finishPrepareProgress_bar:MovieClip /*0,0(0.5,0.5) 58.7x2.25 frames:1*/;
		private var mc_startPrepareProgress_bar:MovieClip /*0,0(0.5,0.5) 58.7x2.25 frames:1*/;
		private var mc_tfChild:TextField /*41.7,-0.5(39.7,-2.5) 12.35x17.25*/;
		private var mc_btnFinish:MovieClip /*33.65,5.4(28.95,0.7) 9.4x9.4 frames:1*/;
		private var mc_btnStart:MovieClip /*21.4,5.4(16.7,0.7) 9.4x9.4 frames:1*/;
		private var _mc:MovieClip;
		private var initial:MCPlayForwardFromToAction;
		private var ending:MCPlayForwardFromToAction;
		private var timerPrepareToStart:Timer;
		private var timerPrepareToFinish:Timer;
		private var isTimerPrepareToStartComplete:Boolean;
		private var isTimerPrepareToFinishComplete:Boolean;		public var mc_anim:MovieClip;
		private var middleFrame:String;
		public var name:String;

		public function RollWhellAndAnimAction(mc:MovieClip, name:String, startFrame:String, middleFrame:String, mc_anim:MovieClip, endingStartFrame:String = null, endingFinishFrame:String = null) {
			this._mc = mc;
			this.name = name;
			dbg.registerInDisplay(mc);
			
			this.mc_anim = mc_anim;			this.middleFrame = middleFrame;
			
			if(endingStartFrame && endingFinishFrame) {
				initial = new MCPlayForwardFromToAction(mc_anim, DisplayUtils.getFrameByLabel(mc_anim, startFrame), DisplayUtils.getFrameByLabel(mc_anim, middleFrame));
				ending = new MCPlayForwardFromToAction(mc_anim, DisplayUtils.getFrameByLabel(mc_anim, endingStartFrame), DisplayUtils.getFrameByLabel(mc_anim, endingFinishFrame));
			}
			
			mc_flag = MovieClip(mc.flag);
			mc_circle = MovieClip(mc.circle);
			mc_tf = TextField(mc.tf);
			mc_tfState = TextField(mc.tfState);			mc_finishPrepareProgress_bar = MovieClip(mc.finishPrepareProgress.bar);
			mc_startPrepareProgress_bar = MovieClip(mc.startPrepareProgress.bar);
			mc_tfChild = TextField(mc.tfChild);
			mc_tfChild.text = '';
			mc_btnFinish = MovieClip(mc.btnFinish);
			mc_btnStart = MovieClip(mc.btnStart);
			
			MCButton.forInstance(mc_btnStart).addView(new ContrastButtonView(mc_btnStart));			MCButton.forInstance(mc_btnFinish).addView(new ContrastButtonView(mc_btnFinish));
			
			addEventSubscription(mc_btnStart, MouseEvent.CLICK, onBtnStart_Click);			addEventSubscription(mc_btnFinish, MouseEvent.CLICK, onBtnFinish_Click);
			
			mc_tfState.autoSize = TextFieldAutoSize.LEFT;
			mc_tfChild.autoSize = TextFieldAutoSize.LEFT;

			mc_finishPrepareProgress_bar.scaleX = 0;
			mc_startPrepareProgress_bar.scaleX = 0;
			
			mc_tf.text = name;
			
			mc_flag.gotoAndStop(1);
			mc_circle.stop();
			
			timerPrepareToStart = new Timer(50, 10);
			addEventSubscription(timerPrepareToStart, TimerEvent.TIMER, onTimerPrepareToStart_Tick);
			addEventSubscription(timerPrepareToStart, TimerEvent.TIMER_COMPLETE, onTimerPrepareToStart_Complete);
			
			timerPrepareToFinish = new Timer(50, 10);
			addEventSubscription(timerPrepareToFinish, TimerEvent.TIMER, onTimerPrepareToFinish_Tick);
			addEventSubscription(timerPrepareToFinish, TimerEvent.TIMER_COMPLETE, onTimerPrepareToFinish_Complete);
			
			doAfterRunningFlagChanged();
			
			doStateChanged();
		}

		override protected function canBeStarted():Boolean {
			return isTimerPrepareToStartComplete;
		}

		override protected function prepareToStart():void {
			if(!timerPrepareToStart.running) {
				timerPrepareToStart.start();
			}
		}

		override protected function prepareToFinish():void {
			if(!timerPrepareToFinish.running) {
				timerPrepareToFinish.start();
			}		}

		override protected function canBeFinished():Boolean {
			return isTimerPrepareToFinishComplete;
		}

		override protected function doRunning():void {
			dbg.log(name + ' doRunning()');
			mc_circle.play();
		}

		override protected function doIdle():void {
			timerPrepareToFinish.reset();
			timerPrepareToStart.reset();
			isTimerPrepareToStartComplete = false;			isTimerPrepareToFinishComplete = false;
			mc_finishPrepareProgress_bar.scaleX = 0;
			mc_startPrepareProgress_bar.scaleX = 0;
			mc_circle.stop();
			dbg.log(name + ' doIdle()');
		}

		override protected function doAfterRunningFlagChanged():void {
			mc_flag.gotoAndStop(isRunningFlag ? 1 : 2);
		}

		override protected function getInitialAction():Action {
			return initial;
		}

		override protected function doMiddleEnter():void {
		}

		override protected function doMiddleNoChildActionRunningEnter(childPreparedToRun:Action = null):void {
			mc_tfChild.text = 'no child action enter';
			mc_anim.gotoAndStop(middleFrame);
			if(isSelfFinish) {
				finish();
			}
		}

		override protected function doMiddleNoChildActionRunningOut():void {
			mc_tfChild.text = 'no child action out';
		}

		override protected function doChildActionStartRunning(childAction:Action):void {
			mc_tfChild.text = 'child action:' + childAction;
		}

		override protected function doMiddleOut():void {
			mc_tfChild.text = '';
		}

		override protected function getEndingAction():Action {
			return ending;
		}

		override protected function doStateChanged():void {
			if(!mc_tfState) { 
				return; 
			}
			mc_tfState.text = getStateName();
			mc_tfChild.x = mc_tfState.x + mc_tfState.width + 2;
		}

		override protected function canBeRestarted():Boolean {
			return true;
		}

		public function get mc():MovieClip { 
			return _mc;
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onTimerPrepareToStart_Complete(event:Event):void {
			isTimerPrepareToStartComplete = true;
			readyToStart();
		}

		private function onTimerPrepareToFinish_Complete(event:TimerEvent):void {
			isTimerPrepareToFinishComplete = true;
			readyToFinish();
		}

		private function onTimerPrepareToFinish_Tick(event:TimerEvent):void {
			mc_finishPrepareProgress_bar.scaleX = timerPrepareToFinish.currentCount / timerPrepareToFinish.repeatCount;
		}

		private function onTimerPrepareToStart_Tick(event:TimerEvent):void {
			mc_startPrepareProgress_bar.scaleX = timerPrepareToStart.currentCount / timerPrepareToStart.repeatCount;
		}

		private function onBtnFinish_Click(event:MouseEvent):void {
			finish();
		}

		private function onBtnStart_Click(event:MouseEvent):void {
			start();
		}
	}
}
