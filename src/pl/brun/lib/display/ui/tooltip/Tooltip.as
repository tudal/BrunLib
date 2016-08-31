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
package pl.brun.lib.display.ui.tooltip {
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.Base;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.util.DisplayUtils;
	import pl.brun.lib.util.MathUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Marek Brun
	 */
	public class Tooltip extends Base {

		private var _mc:MovieClip;
		private var mc_bg:MovieClip;
		private var mc_triangle:MovieClip;
		private var mc_tf:TextField;
		private var align:Number = 0;
		private var mc_triangle_width:Number;
		private var fromTriangleDistance:Number;
		private var container:DisplayObjectContainer;		private var isVisible:Boolean;
		private var isStickToMouse:Boolean = true;
		public var margin:Number = 0;

		public function Tooltip(mc:MovieClip, container:DisplayObjectContainer = null) {
			dbg.registerInDisplay(mc);
			this._mc = mc;
			mc_bg = MovieClip(mc.bg);
			mc_triangle = MovieClip(mc.triangle);
			mc_tf = TextField(mc.tf);
			
			mc_triangle.gotoAndStop(1);
			mc_triangle.x = mc_triangle.y = 0;
			mc_triangle_width = mc_triangle.width;
			fromTriangleDistance = -mc_bg.y - mc_bg.height;
			
			mc.mouseEnabled = false;
			mc.mouseChildren = false;			mc.cacheAsBitmap = true;
			
			this.container = container ? container : DisplayObjectContainer(RootProvider.getRoot());
			
			if(mc.parent) {
				mc.parent.removeChild(mc);
			}
		}

		public function get mc():MovieClip { 
			return _mc; 
		}

		public function setTriangleFrame(frame:uint):void {
			mc_triangle.gotoAndStop(frame);
		}

		public function setIsVisible(visible:Boolean):void {
			if(isVisible == visible) { 
				return; 
			}
			isVisible = visible;
			if(isVisible) {
				container.addChildAt(mc, container.numChildren);
				if(isStickToMouse) {
					root.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove), false, 0, true;
					setPositionByMouse();
				}
			} else {
				mc.parent.removeChild(mc);
				root.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}

		public function setIsStickToMouse(stickToMouse:Boolean):void {
			if(isStickToMouse == stickToMouse) { 
				return; 
			}
			isStickToMouse = stickToMouse;
		}

		public function setPosition(x:Number, y:Number):void {
			mc.x = x;			mc.y = y;
		}

		public function setPositionFromMC(x:Number, y:Number, fromMC:DisplayObjectContainer):void {
			mc.x = DisplayUtils.setGlobalPositionXToOtherDisplayPositionX(fromMC, container, x);
			mc.y = DisplayUtils.setGlobalPositionYToOtherDisplayPositionY(fromMC, container, y);
		}

		public function setText(text:String, show:Boolean = true, angleToCenterByMouse:Boolean = false):void {
			mc_tf.htmlText = text;
			mc_tf.width = mc_tf.textWidth + 5;			mc_tf.height = mc_tf.textHeight + 5;
			mc_bg.width = mc_tf.width + 4 + margin * 2;			mc_bg.height = mc_tf.height + 4 + margin * 2;
			if(angleToCenterByMouse) {
				var stage:Stage = StageProvider.getStage();
				setAlignByAngle(MathUtils.getAngleByPoints(stage.stageWidth / 2, stage.mouseX, stage.stageHeight / 2, stage.mouseY));
			}
			drawAlign();
			setIsVisible(show);
		}

		public function setAlign(align:Number):void {
			this.align = MathUtils.scopeRoll(0, 4, align);
			drawAlign();
		}

		public function setAlignByAngle(angle:Number):void {
			angle = MathUtils.scopeRoll(0, 360, angle);
			setAlign(((angle - 45) / 90) % 4);
		}

		protected function drawAlign():void {
			mc_triangle.rotation = 0;
			var align01:Number = align % 1;
			mc_triangle.rotation = int(align) * 90;
			
			if(align < 1) {
				mc_bg.y = -mc_bg.height - fromTriangleDistance;
				mc_bg.x = -(mc_bg.width - mc_triangle_width) * (1 - align01) - mc_triangle_width / 2;
			}else if(align < 2) {
				mc_bg.x = fromTriangleDistance;
				mc_bg.y = -(mc_bg.height - mc_triangle_width) * (1 - align01) - mc_triangle_width / 2;
			}else if(align < 3) {
				mc_bg.y = fromTriangleDistance;
				mc_bg.x = -(mc_bg.width - mc_triangle_width) * align01 - mc_triangle_width / 2;
			} else {
				mc_bg.x = -mc_bg.width - fromTriangleDistance;
				mc_bg.y = -(mc_bg.height - mc_triangle_width) * align01 - mc_triangle_width / 2;
			}
			
			mc_bg.x = int(mc_bg.x);
			mc_bg.y = int(mc_bg.y);
			mc_tf.x = mc_bg.x + mc_bg.width / 2 - mc_tf.width / 2;			mc_tf.y = mc_bg.y + mc_bg.height / 2 - mc_tf.height / 2;
		}

		private function setPositionByMouse():void {
			setPosition(mc.parent.mouseX, mc.parent.mouseY);
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		protected function onMouseMove(event:MouseEvent):void {
			setPositionByMouse();
		}
	}
}
