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
package pl.brun.lib.display.tools {
	import pl.brun.lib.debugger.DebugServiceProxy;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * 
	 * MCRasterizer will replace all vectors with bitmap to gain more FPS.
	 * 
	 * usage:
	 * MCRasterizer.rasterize(mc); - it can be used multiple time on the same instance 
	 * 
	 * If you planning to use multiple instances of the same library object, please
	 * give it a class name. Then bitmap data from frames will be created only once and shared
	 * amongst all instances. To be sure that all rasterized clips have class name, set
	 * "onlyMCWithClassName" static variable for "true" before rasterizing.
	 * You can also setup warning "maxUsedMBError"
	 * 
	 * MCRasterizer will create and store BitmapData for every frame of your
	 * animation so if you rasterize loong and big animation please check memory
	 * consumption (static variable "usedMemory").
	 * 
	 * Size an position of every screenshot bitmap will be the same as bounding box of 
	 * represented frame. If you want to set a specific area of that screenshot
	 * create clip named "rasterArea" - his bounding box will be used instead.
	 * 
	 * While clip is out of stage MC is paused with MCPauser.
	 * 
	 * WARNING: clip (class) will be rasterized only after clip play all frames.
	 * If it's library instance is already initialized - then rasterizing
	 * starts immediately.
	 * 
	 * WARNING: if you sure there's class for MovieClip and still there's no
	 * class assigned - try set instance name for that clip. It often helps
	 * in such situations (looks like some flash optymalization)
	 * 
	 * 
	 * Events:
	 *  - Event.COMPLETE - when rasterizing is complete. Event is not dispatched
	 *  when rasterizing of that class was complete before. Please check that with
	 *  "getIsRasterized()"
	 * 
	 * @author Marek Brun
	 */
	public class MCRasterizer extends EventDispatcher {
		/** Current sum of used memory for creating bitmaps */
		public static var usedMemoryKB:uint;
		/** After used more MB than specified in maxUsedMBError MCRasterizer will throw error */
		public static var maxUsedMBError:Number = 300;
		/**
		 * If you want to make sure that all rasterized MovieClip's have 
		 * created class by flash (so that rasterize bitmaps can be shared)
		 * set walue to "true" 
		 */
		public static var onlyMCWithClassName:Boolean = false;
		/**
		 * Max used MB rrror will be throw only once.
		 */
		private static var isBeenMaxUsedMBError:Boolean;
		public var _isBitmapSmoothing:Boolean = true;
		/**
		 * Store rasterized bitmaps information by class so that can be reused
		 * 
		 * key - String
		 * value - RasterizeInfo
		 */
		private static var dictClassName_rasterizeInfo:Dictionary = new Dictionary(true);
		/** Rasterized clip */
		private var _mc:MovieClip;
		/** bitmapData holder */
		private var bitmapDisplay:Bitmap;
		private var _rasterizeInfo:RasterizeInfo;
		private var useCache:Boolean;
		private var dbg:DebugServiceProxy;

		/**
		 * Accesible only by MCRasterizer.rasterize static method.
		 */
		public function MCRasterizer(access:Private, mc:MovieClip, useCache:Boolean) {
			dbg = DebugServiceProxy.forInstance(this)
			this.useCache = useCache;
			this._mc = mc;
			// mc.alpha=0.1;
			// since MovieClip is dynamic class we can pass custom field
			mc.isRasterized = false;

			if (useCache) {
				var className:String = getQualifiedClassName(mc);
				// if mc class name is flash.display::MovieClip it means that that
				// instance does not have created class
				if (className == 'flash.display::MovieClip') {
					if (onlyMCWithClassName) {
						throw new IllegalOperationError('Please setup class name for rasterized MovieClip (instance:' + mc.name + ')');
					} else {
						_rasterizeInfo = createRasterizeInfo(mc);
					}
				} else {
					if (!dictClassName_rasterizeInfo[className]) {
						dictClassName_rasterizeInfo[className] = createRasterizeInfo(mc);
					}
					_rasterizeInfo = dictClassName_rasterizeInfo[className];
				}
			} else {
				_rasterizeInfo = createRasterizeInfo(mc)
			}

			bitmapDisplay = new Bitmap();

			if (_rasterizeInfo.gotAllFramesBitmaps) {
				startRasterizing();
			} else {
				mc.addEventListener(Event.ENTER_FRAME, onEF_WhileGettingBitmaps);
			}
		}

		/**
		 * Sets Bitmap.bitmapSmoothing from used Bitmap instance
		 */
		public function set isBitmapSmoothing(v:Boolean):void {
			if (_isBitmapSmoothing == v) {
				return;
			}
			_isBitmapSmoothing = v;
			if (getIsRasterized()) {
				rasterizeCurrentFrame();
			}
		}

		public function get isBitmapSmoothing():Boolean {
			return _isBitmapSmoothing;
		}

		/**
		 * @return true when rasterizing is started
		 */
		public function getIsRasterized():Boolean {
			return _rasterizeInfo.gotAllFramesBitmaps;
		}

		private function get mc():MovieClip {
			return _mc;
		}

		private function startRasterizing():void {
			// instead using EnterFrame, MCRasterizer use addFrameScript
			// wchich will work only if there's really an a "enter frame"
			for (var i:uint = 1;i < mc.totalFrames + 1;i++) {
				mc.addFrameScript(i - 1, rasterizeCurrentFrame);
			}
			mc.removeEventListener(Event.ENTER_FRAME, onEF_WhileGettingBitmaps);
			mc.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			mc.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			mc.isRasterized = true;
			rasterizeCurrentFrame();
		}

		private static function createRasterizeInfo(mc:MovieClip):RasterizeInfo {
			var rasterizeInfo:RasterizeInfo = new RasterizeInfo(getQualifiedClassName(mc), mc.totalFrames);
			return rasterizeInfo;
		}

		private function rasterizeCurrentFrame():void {
			if (!mc.stage) {
				return;
			}

			// removing all children
			var child:DisplayObject
			try {
				child = mc.getChildAt(0)
			} catch(error:Error) {
			}
			while (child) {
				stopAll(child)
				mc.removeChild(child)
				try {
					child = mc.getChildAt(0)
				} catch(error:Error) {
					break
				}
			}

			// adding bitmap holder
			mc.addChild(bitmapDisplay);

			bitmapDisplay.smoothing = isBitmapSmoothing;
			bitmapDisplay.bitmapData = _rasterizeInfo.bitmaps[mc.currentFrame];
			bitmapDisplay.x = _rasterizeInfo.bounds[mc.currentFrame].x;
			bitmapDisplay.y = _rasterizeInfo.bounds[mc.currentFrame].y;
		}

		public function getCurrentBitmapData():BitmapData {
			return bitmapDisplay.bitmapData;
		}

		public function getCurrentBitmap():Bitmap {
			return bitmapDisplay;
		}

		/**
		 * Returns an area of grabbed screenshot.
		 * If you want to set a specific area of that screenshot create
		 * clip named "rasterArea" - his bounding box will be used instead.
		 */
		private function getBounds(display:DisplayObjectContainer):Rectangle {
			if (display.getChildByName('rasterArea')) {
				var ra:MovieClip = MovieClip(display.getChildByName('rasterArea'));
				display.removeChild(display.getChildByName('rasterArea'));
				return new Rectangle(ra.x, ra.y, ra.width, ra.height);
			}
			return display.getBounds(display);
		}

		private static function getBitmapDataByDisplay(display:DisplayObjectContainer, bounds:Rectangle):BitmapData {
			var bd:BitmapData = new BitmapData(Math.max(1, Math.min(2880, bounds.width)), Math.max(1, Math.min(2880, bounds.height)), true, 0x00000000);
			bd.draw(display, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			return bd;
		}

		/**
		 * This method can be called for the same MovieClip instance multiple times -
		 * MCRasterizer instance for that MovieClip will be created only once. 
		 */
		public static function rasterize(mc:MovieClip, useCache:Boolean = true):MCRasterizer {
			if (!servicedObjects[mc]) {
				servicedObjects[mc] = new MCRasterizer(null, mc, useCache);
			}
			return servicedObjects[mc];
		}

		public static function getChildren(display:DisplayObjectContainer):Array /*of DisplayObject*/
 		{
			var childs:Array = [];
			var i:uint;
			for (i = 0;i < display.numChildren;i++) {
				childs.push(display.getChildAt(i));
			}
			return childs;
		}

		public static function stopAll(display:DisplayObject):void {
			if (display is DisplayObjectContainer) {
				affectAllChildren(DisplayObjectContainer(display));
			}
		}

		private static function affectAllChildren(display:DisplayObjectContainer):void {
			if (display is MovieClip) {
				MovieClip(display).stop();
			}
			var children:Array = getChildren(display);
			var i:uint;
			var loop:DisplayObject;
			for (i = 0;i < children.length;i++) {
				loop = children[i];
				if (loop is DisplayObjectContainer) {
					affectAllChildren(DisplayObjectContainer(loop));
				}
			}
		}

		private static const servicedObjects:Dictionary = new Dictionary(true);

		protected function onEF_WhileGettingBitmaps(event:Event):void {
			if (!_rasterizeInfo.getGotFrameData(mc.currentFrame)) {
				// getting bitmap for current frame
				var bounds:Rectangle = getBounds(mc);
				dbg.logv("rasterize")
				var bd:BitmapData = getBitmapDataByDisplay(mc, bounds);
				_rasterizeInfo.setFrameData(mc.currentFrame, bd, bounds);
				usedMemoryKB += ((bd.width * bd.height * 32) / 8) / 1024;
			}
			if (_rasterizeInfo.gotAllFramesBitmaps) {
				// clip is  fully rasterized
				startRasterizing();
				dispatchEvent(new Event(Event.COMPLETE));
			}
			if (usedMemoryKB / 1024 > maxUsedMBError && !isBeenMaxUsedMBError) {
				isBeenMaxUsedMBError = true;
				throw new Error('Memory used for rasterizing is above ' + maxUsedMBError + ' MB');
			}
		}

		protected function onAddedToStage(event:Event):void {
			rasterizeCurrentFrame();
			MCPauser.forInstance(mc).resume();
		}

		protected function onRemovedFromStage(event:Event):void {
			MCPauser.forInstance(mc).pause();
		}

		public function get rasterizeInfo():RasterizeInfo {
			return _rasterizeInfo;
		}

		public function dispose():void {
			mc.removeEventListener(Event.ENTER_FRAME, onEF_WhileGettingBitmaps)
			mc.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage)
			delete dictClassName_rasterizeInfo[getQualifiedClassName(mc)]
			if (_rasterizeInfo) _rasterizeInfo.dispose();
			_rasterizeInfo = null
		}
	}
}
internal class Private {
}

