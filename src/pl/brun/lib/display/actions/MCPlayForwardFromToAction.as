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
package pl.brun.lib.display.actions {
	import flash.display.DisplayObject;
	import pl.brun.lib.models.IDisplayObjectOperator;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.display.tools.MCFrameEnterDispatcher;

	import flash.display.MovieClip;

	/**
	 * @author Marek Brun
	 */
	public class MCPlayForwardFromToAction extends Action implements IDisplayObjectOperator {
		private var _mc:MovieClip;
		private var startFrame:uint;
		private var targetFrame:uint;

		public function MCPlayForwardFromToAction(mc:MovieClip, startFrame:uint, targetFrame:uint = 0) {
			this._mc = mc;
			this.startFrame = startFrame;
			if (targetFrame == 0) {
				this.targetFrame = mc.totalFrames
			}else{
				this.targetFrame = targetFrame;
			}
			// if(startFrame > targetFrame) {
			// throw new IllegalOperationError("Start frame (" + startFrame + ") must be lower than target frame (" + targetFrame + ")");
			// }
		}

		override protected function doRunning():void {
			mc.gotoAndPlay(startFrame);
			MCFrameEnterDispatcher.forInstance(mc).addFrameListener(targetFrame, onTargetFrame);
		}

		override protected function doIdle():void {
			MCFrameEnterDispatcher.forInstance(mc).removeFrameListener(targetFrame, onTargetFrame);
		}

		override public function dispose():void {
			MCFrameEnterDispatcher.forInstance(mc).removeFrameListener(targetFrame, onTargetFrame);
		}

		override protected function canBeFinished():Boolean {
			if (super.canBeFinished()) {
				return mc.currentFrame == targetFrame;
			}
			return false;
		}

		public function get mc():MovieClip {
			return _mc;
		}

		protected function onTargetFrame():void {
			MCFrameEnterDispatcher.forInstance(mc).removeFrameListener(targetFrame, onTargetFrame);
			mc.stop();
			finish();
		}

		public function get display():DisplayObject {
			return _mc;
		}
	}
}
