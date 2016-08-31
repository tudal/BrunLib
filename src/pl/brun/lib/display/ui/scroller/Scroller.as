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
package pl.brun.lib.display.ui.scroller {
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.display.button.ButtonEvent;
	import pl.brun.lib.display.button.SpriteButton;
	import pl.brun.lib.display.button.views.ButtonViewFactoryByLabel;
	import pl.brun.lib.display.button.views.cursorButtonViews.DraggingCursorButtonView;
	import pl.brun.lib.display.ui.threeParts.ThreePartsDisplay;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.models.IScroller;
	import pl.brun.lib.tools.CallOncePerFrame;

	import flash.display.MovieClip;

	[Event(name="positionChanged", type="pl.brun.lib.events.PositionEvent")]
	/**
	 * This scroler can't be scrolled "by itself". Your controllser or model
	 * should recive PositionEvent.POSITION_REQUEST event, change its state
	 * and then change scroller (view) by model. 
	 * 
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public class Scroller extends DisplayBase implements IScroller {
		public var isVisibleWhenNoScroll:Boolean;
		public var minTabSize:Number = 20;
		private var mc_btnTap:MovieClip /*0,0(0,0) 16x28 frames:1*/;
		private var mc_btnTap_humps:MovieClip /*8,14.65(4.5,10.65) 7x8 frames:1*/;
		private var mc_btnTap_side0:MovieClip /*0,0(0,0) 16x4 frames:4*/;
		private var mc_btnTap_mid:MovieClip /*0,4(0,4) 16x20 frames:5*/;
		private var mc_btnTap_side1:MovieClip /*0,24(0,24) 16x4 frames:5*/;
		private var mc_bg:MovieClip /*0,0(0,0) 16x66.8 frames:1*/;
		private var _size:Number = 0;
		private var tap:ThreePartsDisplay;
		private var btnTap:SpriteButton;
		private var position:Number;
		private var visibleArea:Number;
		private var totalArea:Number;
		private var mc:MovieClip;
		private var positionWhenPress:Number;

		public function Scroller(mc:MovieClip, cursor:Boolean = true) {
			super(mc);
			this.mc = mc;
			mc_btnTap = MovieClip(mc.btnTap);
			mc_btnTap_humps = MovieClip(mc.btnTap.humps);
			mc_btnTap_side0 = MovieClip(mc.btnTap.side0);
			mc_btnTap_mid = MovieClip(mc.btnTap.mid);
			mc_btnTap_side1 = MovieClip(mc.btnTap.side1);
			mc_bg = MovieClip(mc.bg);

			tap = new ThreePartsDisplay(mc_btnTap);
			btnTap = new SpriteButton(mc_btnTap);
			btnTap.addEventListener(ButtonEvent.PRESS, onBtnTap_Press);
			btnTap.addEventListener(ButtonEvent.DRAG_MOVE, onBtnTap_DragMove);
			btnTap.addViews(ButtonViewFactoryByLabel.createViewsByLabels(mc_btnTap_mid));
			btnTap.addViews(ButtonViewFactoryByLabel.createViewsByLabels(mc_btnTap_side0));
			btnTap.addViews(ButtonViewFactoryByLabel.createViewsByLabels(mc_btnTap_side1));
			if (cursor) {
				btnTap.addView(new DraggingCursorButtonView());
			}

			size = mc_bg.height * mc.scaleY;
			mc.scaleY = 1;

			setScroll(0, 0.2, 1);
		}

		public function get size():Number {
			return _size;
		}

		public function set size(value:Number):void {
			_size = value;
			mc_bg.height = value;
			draw();
		}

		private function draw():void {
			if (!CallOncePerFrame.call(draw)) {
				return;
			}

			// mc.visible = !(!isVisibleWhenNoScroll && visibleArea == totalArea);
			if (isVisibleWhenNoScroll) {
				mc.visible = true
			} else {
				mc.visible = visibleArea < totalArea
			}
			tap.size = Math.max(minTabSize, size * (visibleArea / totalArea));
			var moveArea:Number = size - tap.size;
			mc_btnTap.y = position * moveArea;
			mc_btnTap_humps.y = tap.size / 2;
		}

		public function setScroll(position:Number, visibleArea:Number, totalArea:Number):void {
			this.totalArea = totalArea;
			this.visibleArea = visibleArea;
			this.position = position;
			draw();
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onBtnTap_Press(event:ButtonEvent):void {
			positionWhenPress = position;
		}

		private function onBtnTap_DragMove(event:ButtonEvent):void {
			var moveArea:Number = size - tap.size;
			var newPosition:Number = positionWhenPress + btnTap.stageMoveY / moveArea;

			newPosition = Math.max(0, Math.min(1, newPosition));

			dispatchEvent(new PositionEvent(PositionEvent.POSITION_REQUEST, newPosition));
		}
	}
}
