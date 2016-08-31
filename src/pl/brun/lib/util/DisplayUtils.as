/* * Copyright 2009 Marek Brun *  * Licensed under the Apache License, Version 2.0 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at * *     http://www.apache.org/licenses/LICENSE-2.0 *     * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. * */package pl.brun.lib.util {	import com.gskinner.geom.ColorMatrix;	import flash.display.Bitmap;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.display.FrameLabel;	import flash.display.InteractiveObject;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.filters.ColorMatrixFilter;	import flash.geom.ColorTransform;	import flash.geom.Point;	import flash.geom.Rectangle;	import flash.utils.getDefinitionByName;	import flash.utils.getQualifiedClassName;	/**	
	 * @author Marek Brun	
	 */	public class DisplayUtils {		public static function getFrameByLabel(mc:MovieClip, targetLabel:String):int {			var i:uint;			var loopLabel:FrameLabel;			for (i = 0;i < mc.currentLabels.length;i++) {				loopLabel = mc.currentLabels[i];				if (loopLabel.name === targetLabel) {					return loopLabel.frame;				}			}			return 0;		}		public static function getLabelByFrame(mc:MovieClip, frame:int):String {			var i:uint;			var loopLabel:FrameLabel;			for (i = 0;i < mc.currentLabels.length;i++) {				loopLabel = mc.currentLabels[i];				if (loopLabel.frame === frame) {					return loopLabel.name;				}			}			return null;		}		public static function getFrameByTotalFrames01(mc:MovieClip, tfN01:Number):uint {			return 1 + Math.round(tfN01 * (mc.totalFrames - 1));		}		public static function gotLibaryLikage(display:DisplayObject):Boolean {			var clazz:Class = Class(Object(display).constructor);			return getQualifiedClassName(clazz) != "flash.display::MovieClip";		}		public static function duplicateDisplayObject(target:DisplayObject):DisplayObject {			var TargetClass:Class = Class(Object(target).constructor);			if (getQualifiedClassName(TargetClass) == "flash.display::MovieClip") {				throw new Error("Please create library linked class name for instance : " + target.parent.name + '.' + target.name);			}			var duplicate:DisplayObject = new TargetClass();			return duplicate;		}		public static function swapMCDepthToFront(mc:DisplayObject):void {			mc.parent.setChildIndex(mc, mc.parent.numChildren - 1);		}		public static function getGlobalY(mc:DisplayObject, plusY:Number = 0):Number {			var obj:Point = new Point(0, plusY);			return mc.localToGlobal(obj).y;		}		public static function setGlobalY(mc:DisplayObject, val:Number):void {			var obj:Point = new Point(getGlobalX(mc), val);			obj = mc.parent.globalToLocal(obj);			mc.x = obj.x;			mc.y = obj.y;		}		public static function getGlobalX(mc:DisplayObject, plusX:Number = 0):Number {			var obj:Point = new Point(plusX, 0);			return mc.localToGlobal(obj).x;		}		public static function setGlobalX(mc:DisplayObject, val:Number):void {			var obj:Point = new Point(val, getGlobalY(mc));			obj = mc.parent.globalToLocal(obj);			mc.x = obj.x;			mc.y = obj.y;		}		public static function setGlobalPositionXToOtherDisplayPositionX(mcFrom:DisplayObject, mcTo:DisplayObject, plusX:Number = 0):Number {			var obj:Point = new Point(plusX, 0);			obj = mcFrom.localToGlobal(obj);			obj = mcTo.globalToLocal(obj);			return obj.x;		}		public static function setGlobalPositionYToOtherDisplayPositionY(mcFrom:DisplayObject, mcTo:DisplayObject, plusY:Number = 0):Number {			var obj:Point = new Point(0, plusY);			obj = mcFrom.localToGlobal(obj);			obj = mcTo.globalToLocal(obj);			return obj.y;		}		public static function snapPositionToPixels(mc:DisplayObject):void {			var obj:Point = new Point(0, 0);			obj = mc.localToGlobal(obj);			obj.x = Math.round(obj.x);			obj.y = Math.round(obj.y);			obj = mc.globalToLocal(obj);			mc.x = mc.x + obj.x;			mc.y = mc.y + obj.y;		}		public static function createRect(rgb:Number = 0xFFFFFF, width:Number = 100, height:Number = 100, alpha:Number = 1):Sprite {			var sprite:Sprite = new Sprite();			sprite.graphics.beginFill(rgb, alpha);			sprite.graphics.drawRect(0, 0, width, height);			return sprite;		}		public static function createAlpha0BoundBoxRect(display:DisplayObject, boundsTargetCoordinateSpace:DisplayObject = null):Sprite {			var sprite:Sprite = new Sprite();			sprite.alpha = 0;			sprite.name = 'alpha0';			sprite.graphics.beginFill(0x000000);			var bounds:Rectangle = display.getBounds(boundsTargetCoordinateSpace ? boundsTargetCoordinateSpace : display);			sprite.graphics.drawRect(0, 0, bounds.width, bounds.height);			sprite.x = bounds.x;			sprite.y = bounds.y;			return sprite;		}		public static function getParents(disp:DisplayObject):Array /*of DisplayObjectContainer*/ 		{			var parents:Array = [];			var parent:DisplayObject = disp;			while (parent.parent) {				parents.push(parent.parent);				parent = parent.parent;			}			parents.pop();			return parents;		}		public static function getPatch(display:DisplayObject):Array /*of String*/ 		{			var parents:Array = getParents(display);			var patch:Array = [];			while (parents.length) {				patch.push(parents.pop().name);			}			patch.push(display.name);			return patch;		}		public static function getChildren(display:DisplayObjectContainer):Array /*of DisplayObject*/ 		{			var childs:Array = [];			var i:uint;			for (i = 0;i < display.numChildren;i++) {				childs.push(display.getChildAt(i));			}			return childs;		}		public static function addChildBelowChild(childToAdd:DisplayObject, child:DisplayObject):void {			child.parent.addChildAt(childToAdd, child.parent.getChildIndex(child));		}		public static function addChildOverChild(childToAdd:DisplayObject, child:DisplayObject):void {			child.parent.addChildAt(childToAdd, child.parent.getChildIndex(child) + 1);		}		/**		
		 * error-free removeChild		
		 */		public static function removeChild(display:DisplayObject):void {			if (display.parent) {				display.parent.removeChild(display);			}		}		/**		
		 * error-free addChild		
		 */		public static function addChild(parent:DisplayObjectContainer, display:DisplayObject, depth:int = -1):void {			if (display.parent != parent) {				if (depth > -1) {					parent.addChildAt(display, depth);				} else {					parent.addChild(display);				}			}		}		/**		 * error-free addChild and removeChild		 */		public static function setIsAdded(isAdded:Boolean, container:DisplayObjectContainer, child:DisplayObject):void {			if (isAdded) {				container.addChild(child)			} else {				if (child.parent && child.parent == container) {					container.removeChild(child)				}			}		}		public static function removeAllChildren(mc:DisplayObjectContainer, dispose:Boolean = true):void {			if (dispose) {				if (mc is MovieClip) {					MovieClip(mc).stop();				}				while (mc.numChildren) {					disposeDisplay(mc.getChildAt(0));				}			} else {				while (mc.numChildren) {					mc.removeChild(mc.getChildAt(0));				}			}		}		public static function removeChildren(children:Array):void {			var i:uint;			var loop:DisplayObject;			for (i = 0;i < children.length;i++) {				loop = children[i];				removeChild(loop);			}		}		public static function addChildren(children:Array, container:DisplayObjectContainer):void {			var i:uint;			var loop:DisplayObject;			for (i = 0;i < children.length;i++) {				loop = children[i];				container.addChild(loop);			}		}		public static function tint(display:DisplayObject, color:uint):void {			var ct:ColorTransform = display.transform.colorTransform;			ct.color = color;			display.transform.colorTransform = ct;		}		/**		 * @param multiplier - 0 to 1, 1 - full tint, 0.5- half tint, 0 - no tint		 */		public static function tintM(display:DisplayObject, color:uint, multiplier:Number = 0):void {			var mul:Number = multiplier;			var ctMul:Number = (1 - mul);			var ctBlueOff:Number = Math.round(mul * ( color & 0xFF ));			var ctRedOff:Number = Math.round(mul * (( color >> 16 ) & 0xFF));			var ctGreenOff:Number = Math.round(mul * ( (color >> 8) & 0xFF ));			var ct:ColorTransform = new ColorTransform(ctMul, ctMul, ctMul, 1, ctRedOff, ctGreenOff, ctBlueOff, 0);			display.transform.colorTransform = ct;		}		public static function untint(display:DisplayObject):void {			display.transform.colorTransform = new ColorTransform();		}		public static function replaceDisplays(displayToAdd:DisplayObject, displayToRemove:DisplayObject):void {			var index:uint = displayToAdd.parent.getChildIndex(displayToAdd);			var parent:DisplayObjectContainer = displayToAdd.parent;			parent.removeChild(displayToAdd);			parent.addChildAt(displayToRemove, index);		}		public static function setColor(mc:DisplayObject, color:Number):void {			var ct:ColorTransform = mc.transform.colorTransform;			ct.color = color;			mc.transform.colorTransform = ct;		}		/*		 *  saturation od -1 do 1		 */		public static function setSaturation(saturation:Number, display:DisplayObject):void {			if (saturation < -1) saturation = -1			if (saturation > 1) saturation = 1			var colorMatrix:ColorMatrix = new ColorMatrix((new ColorMatrixFilter()).matrix);			colorMatrix.adjustSaturation(saturation * 100);			display.filters = [new ColorMatrixFilter(colorMatrix)]		}		public static function setRGB(mc:MovieClip, r:Number, g:Number, b:Number):void {			var ct:ColorTransform = mc.transform.colorTransform;			ct.redOffset = r;			ct.greenOffset = g;			ct.blueOffset = b;			mc.transform.colorTransform = ct;		}		public static function swapDepthToOthersFront(toTop:DisplayObject, downs:Array):void {			var i:uint;			var loop:DisplayObject, top:DisplayObject = downs[0];			for (i = 1;i < downs.length;i++) {				loop = downs[i];				if (loop == toTop) {					continue;				}				if (loop.parent.getChildIndex(loop) > top.parent.getChildIndex(top)) {					top = loop;				}			}			if (toTop.parent.getChildIndex(toTop) < top.parent.getChildIndex(top)) {				toTop.parent.setChildIndex(toTop, top.parent.getChildIndex(top));			}		}		public static function getChildrenWithPostfix(mc:DisplayObjectContainer, postfix:String):Array/*of MovieClip*/ 		{			var finds:Array = [];			var allMCS:Array = getChildren(mc);			var i:uint;			var loop:DisplayObject;			for (i = 0;i < allMCS.length;i++) {				loop = allMCS[i];				if (loop.name.indexOf(postfix) == 0) {					finds.push(loop);				}			}			return finds;		}		public static function getChildrenByPostfixCount(mc:DisplayObjectContainer, name:String, startCount:int = 0):Array/*of DisplayObject*/ 		{			var i:int = startCount;			var found:Array /*of DisplayObject*/ 			= [];			while (mc.getChildByName(name + i)) {				found.push(mc.getChildByName(name + i));				i++;			}			return found;		}		public static function getChildByPostfix(mc:DisplayObjectContainer, postfix:String):DisplayObject {			var i:uint;			for (i = 0;i < mc.numChildren;i++) {				if (mc.getChildAt(i).name.substr(0, postfix.length) == postfix) {					return mc.getChildAt(i);				}			}			return null;		}		public static function stopAll(display:DisplayObjectContainer, isGoto1stFrame:Boolean = false, ignoreList:Array = null):void {			affectAllChildren(display, isGoto1stFrame ? AFFFECT_ALL_CHILDS_ACTTION_GOTOANDSTOP1 : AFFFECT_ALL_CHILDS_ACTTION_STOP, ignoreList);		}		public static function playAll(display:DisplayObjectContainer, isGoto1stFrame:Boolean = false, ignoreList:Array = null):void {			affectAllChildren(display, isGoto1stFrame ? AFFFECT_ALL_CHILDS_ACTTION_GOTOANDPLAY1 : AFFFECT_ALL_CHILDS_ACTTION_PLAY, ignoreList);		}		private static const AFFFECT_ALL_CHILDS_ACTTION_STOP:uint = 0;		private static const AFFFECT_ALL_CHILDS_ACTTION_GOTOANDSTOP1:uint = 1;		private static const AFFFECT_ALL_CHILDS_ACTTION_PLAY:uint = 2;		private static const AFFFECT_ALL_CHILDS_ACTTION_GOTOANDPLAY1:uint = 3;		private static function affectAllChildren(display:DisplayObjectContainer, action:uint, ignoreList:Array = null):void {			if (ignoreList && ignoreList.indexOf(display) > -1) {				return;			}			if (display is MovieClip) {				switch(action) {					case AFFFECT_ALL_CHILDS_ACTTION_STOP:						MovieClip(display).stop();						break;					case AFFFECT_ALL_CHILDS_ACTTION_PLAY:						MovieClip(display).play();						break;					case AFFFECT_ALL_CHILDS_ACTTION_GOTOANDPLAY1:						MovieClip(display).gotoAndPlay(1);						break;					case AFFFECT_ALL_CHILDS_ACTTION_GOTOANDSTOP1:						MovieClip(display).gotoAndStop(1);						break;				}			}			var children:Array = getChildren(display);			var i:uint;			var loop:DisplayObject;			for (i = 0;i < children.length;i++) {				loop = children[i];				if (loop is DisplayObjectContainer) {					affectAllChildren(DisplayObjectContainer(loop), action, ignoreList);				}			}		}		public static function disposeDisplay(display:DisplayObject):void {			if (display is DisplayObjectContainer) {				var children:Array = getChildren(DisplayObjectContainer(display));				var i:uint;				var loop:DisplayObject;				for (i = 0;i < children.length;i++) {					loop = children[i];					if (!loop) {						continue;					}					disposeDisplay(loop);				}			}			display.width = 1;			display.height = 1;			display.cacheAsBitmap = false;			display.alpha = 1;			if (display.parent) {				try {					display.parent.removeChild(display);				} catch(e:*) {				}			}			display.filters = [];			if (display is MovieClip) {				MovieClip(display).stop();			}		}		public static function disposeDisplays(displays:Array/*of DisplayObject*/):void {			var i:uint;			for (i = 0;i < displays.length;i++) {				disposeDisplay(displays[i]);			}		}		public static function createMovieClipByClassName(className:String):MovieClip {			var clazz:Class = Class(getDefinitionByName(className));			return MovieClip(new clazz());		}		public static function alignSizeTo(mc:DisplayObject, toAlign:DisplayObject):void {			var bounds:Rectangle = toAlign.getBounds(mc.parent);			mc.x = bounds.x;			mc.y = bounds.y;			mc.width = bounds.width;			mc.height = bounds.height;		}		public static function setSmoothingToAllBitmaps(display:DisplayObject):void {			if (display is DisplayObjectContainer) {				var children:Array = getChildren(DisplayObjectContainer(display));				var i:uint;				var child:DisplayObject;				for (i = 0;i < children.length;i++) {					child = children[i];					setSmoothingToAllBitmaps(child);				}			} else if (display is Bitmap) {				Bitmap(display).smoothing = true;				Bitmap(display).bitmapData = Bitmap(display).bitmapData;				Bitmap(display).smoothing = true;			}		}		public static function move(display:DisplayObject, container:Sprite):void {			var ltg:Point = display.parent.localToGlobal(new Point(display.x, display.y));			var gtl:Point = container.globalToLocal(ltg);			container.addChild(display);			display.x = gtl.x;			display.y = gtl.y;		}		public static function disableMouse(displayObjects:Array):void {			for each (var display:InteractiveObject in displayObjects) {				display.mouseEnabled = false				if (display is DisplayObjectContainer) DisplayObjectContainer(display).mouseChildren = false;			}		}		public static function getGlobalScale(d:DisplayObject, byScaleX:Boolean = true):Number {			return getGlobalScaleRecu(d, byScaleX ? d.scaleX : d.scaleY, byScaleX)		}		private static function getGlobalScaleRecu(d:DisplayObject, scale:Number, byScaleX:Boolean = true):Number {			if (d.parent) {				return getGlobalScaleRecu(d.parent, scale *= byScaleX ? d.parent.scaleX : d.parent.scaleY)			}			return scale		}	}}
