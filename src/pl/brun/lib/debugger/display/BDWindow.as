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
package pl.brun.lib.debugger.display {
	import debuggerAssets.BDBGWindowMC;

	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.display.button.ButtonEvent;
	import pl.brun.lib.display.button.InteractiveObjectButton;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.display.button.views.AlphaWhenDisableButtonView;
	import pl.brun.lib.display.button.views.ContrastButtonView;
	import pl.brun.lib.display.button.views.cursorButtonViews.DraggingCursorButtonView;
	import pl.brun.lib.events.SelectEvent;
	import pl.brun.lib.models.BrowseHistory;
	import pl.brun.lib.models.EasyCookie;
	import pl.brun.lib.models.ICookieDataProvider;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Dictionary;

	/**
	 * Events:
	 *  - SelectEvent.SELECT_REQUEST
	 *  - BDLinkEvent.LINK_CALL
	 * 
	 * created: 2009-12-16
	 * @author Marek Brun
	 */
	public class BDWindow extends DisplayBase implements ICookieDataProvider {
		// private static var slices:SliceProvider;
		// private static const blurWhenDisabled:BlurFilter = new BlurFilter(4, 4, 1);
		private static const dropShadowWhenEnabled:DropShadowFilter = new DropShadowFilter(3, 45, 0, .2);
		private var mc:BDBGWindowMC;
		// private var bodyBorderBitmap:Bitmap;
		// private var upBgBitmap:Bitmap;
		private var width:Number;
		private var height:Number;
		private var btnClose:MCButton;
		private var btnHistoryBack:MCButton;
		private var btnHistoryFront:MCButton;
		private var btnCorner:MCButton;
		private var btnCornerPressWidth:Number;
		private var btnCornerPressHeight:Number;
		// private var upBgBitmapHolder:Sprite;
		private var btnUpBg:InteractiveObjectButton;
		private var btnUpBgPressX:Number;
		private var btnUpBgPressY:Number;
		private var currentContent:BDWindowContent;
		private var _isMinimalized:Boolean = false;
		private var _isSelected:Boolean = true;
		private var canBeDeselcted:Boolean = true;
		private var wasMinimalizedBeforeDeselect:Boolean;
		private var dictProvider_Content:Dictionary = new Dictionary(true);
		private var _isOvered:Boolean;
		private var history:BrowseHistory;
		public var cookie:EasyCookie;

		public function BDWindow(provider:IBDWindowContentProvider) {
			mc = new BDBGWindowMC();
			DisplayUtils.stopAll(mc);
			super(mc);

			// if(!slices) {
			// slices = new SliceProvider(mc.body.border, mc.up.bg);
			// }

			// bodyBorderBitmap = new Bitmap(new BitmapData(1, 1), PixelSnapping.ALWAYS, true);
			// mc.body.removeChild(mc.body.border);
			// mc.body.addChildAt(bodyBorderBitmap, 0);

			// upBgBitmap = new Bitmap(new BitmapData(1, 1), PixelSnapping.ALWAYS, true);
			// upBgBitmapHolder = new Sprite();
			// upBgBitmapHolder.addChild(upBgBitmap);
			// mc.up.removeChild(mc.up.bg);
			// mc.up.addChildAt(upBgBitmapHolder, 0);

			btnClose = new MCButton(mc.up.beamButtons.btnClose);
			addEventSubscription(btnClose, MouseEvent.CLICK, onBtnClose_Click);
			btnHistoryBack = new MCButton(mc.up.beamButtons.btnHistoryBack);
			addEventSubscription(btnHistoryBack, MouseEvent.CLICK, onBtnHistoryBack_Click);
			btnHistoryBack.addView(new AlphaWhenDisableButtonView(btnHistoryBack.mc));
			btnHistoryFront = new MCButton(mc.up.beamButtons.btnHistoryFront);
			addEventSubscription(btnHistoryFront, MouseEvent.CLICK, onBtnHistoryFront_Click);
			btnHistoryFront.addView(new AlphaWhenDisableButtonView(btnHistoryFront.mc));
			btnCorner = new MCButton(mc.body.btnCorner);
			addEventSubscription(btnCorner, ButtonEvent.PRESS, onBtnCorner_Press);
			addEventSubscription(btnCorner, ButtonEvent.RELEASE, onBtnCorner_Release);
			addEventSubscription(btnCorner, ButtonEvent.DRAG_MOVE, onBtnCorner_DragMove);
			btnCorner.addView(new DraggingCursorButtonView());
			btnCorner.addView(new ContrastButtonView(mc.body.btnCorner));
			btnUpBg = new InteractiveObjectButton(mc.up.bg);
			addEventSubscription(btnUpBg, ButtonEvent.PRESS, onBtnUpBg_Press);
			addEventSubscription(btnUpBg, ButtonEvent.RELEASE, onBtnUpBg_Release);
			addEventSubscription(btnUpBg, ButtonEvent.DRAG_MOVE, onBtnUpBg_DragMove);
			addEventSubscription(mc.up.bg, MouseEvent.DOUBLE_CLICK, onBtnUpBg_DoubleCick);
			mc.up.bg.doubleClickEnabled = true;
			btnUpBg.addView(new DraggingCursorButtonView());
			btnUpBg.addView(new ContrastButtonView(mc.body.btnCorner));

			mc.up.tfTitle.mouseEnabled = false;

			mc.body.addChildAt(mc.body.content, 0);
			addEventSubscription(mc, MouseEvent.ROLL_OVER, onMC_RollOver);
			addEventSubscription(mc, MouseEvent.ROLL_OUT, onMC_RollOut);

			history = new BrowseHistory();
			addEventSubscription(history, Event.CHANGE, onHistory_Change);

			drawIsSelected();
			setProvider(provider);
			setSize(300, 200);

			drawHistoryButtons();
		}

		public function enableCookie(uniqueName:String):void {
			cookie = new EasyCookie(this, uniqueName, false);
		}

		public function getSharedObjectInitData():Object {
			var obj:Object = {};
			obj.x = 10;
			obj.y = 10;
			obj.width = 300;
			obj.height = 300;
			obj.isMinimalized = false;
			return obj;
		}

		public function applySharedObjectData(data:Object):void {
			// data = getSharedObjectInitData()
			mc.x = data.x;
			mc.y = data.y;
			setSize(data.width, data.height);
			isMinimalized = data.isMinimalized;
			// delayCall(cookie.flush)
		}

		public function getSharedObjectData():Object {
			var obj:Object = {};
			obj.x = mc.x;
			obj.y = mc.y;
			obj.width = width;
			obj.height = height;
			obj.isMinimalized = isMinimalized;
			return obj;
		}

		public function getPropertiesToSave():Object {
			var obj:Object = {};
			obj.x = mc.x;
			obj.y = mc.y;
			obj.width = width;
			obj.height = height;
			obj.isMinimalized = isMinimalized;
			return obj;
		}

		public function applySavedProperties(obj:Object):Object {
			mc.x = obj.x;
			mc.y = obj.y;
			setSize(obj.width, obj.height);
			isMinimalized = obj.isMinimalized;
			return obj;
		}

		private function drawHistoryButtons():void {
			btnHistoryBack.isEnabled = history.getCanGoBack();
			btnHistoryFront.isEnabled = history.getCanGoForward();
		}

		public function get isOvered():Boolean {
			return _isOvered;
		}

		public function setProvider(provider:IBDWindowContentProvider, isHistoryAdd:Boolean = true):void {
			if (!dictProvider_Content[provider]) {
				var content:BDWindowContent = new BDWindowContent(provider, mc.up.tfTitle, mc.body.tfNames);
				dictProvider_Content[provider] = content;
			}
			if (currentContent) {
				currentContent.disable();
				mc.body.content.removeChild(currentContent.container);
			}
			currentContent = dictProvider_Content[provider];
			mc.body.content.addChild(currentContent.container);
			currentContent.enable();
			refreshContentSize();

			if (isHistoryAdd) {
				history.add(provider);
			}
			drawHistoryButtons();
		}

		public function getWidth():Number {
			return width
		}

		public function setSize(width:Number, height:Number):void {
			this.width = width = Math.round(Math.max(width, mc.up.beamButtons.width));
			this.height = height = Math.round(Math.max(height, 50));

			// bodyBorderBitmap.bitmapData = slices.getBGBitmapData(width, height);
			mc.body.border.width = width;
			mc.body.border.height = height;
			mc.body.btnCorner.x = width;
			mc.body.btnCorner.y = height;

			// upBgBitmap.bitmapData = slices.getBeamBitmapData(width);
			mc.up.beamButtons.x = width;
			mc.up.bg.width = width;
			mc.body.tfNames.width = width - mc.body.tfNames.x;
			mc.up.tfTitle.width = width - mc.up.tfTitle.x - mc.up.beamButtons.width - 2;

			refreshContentSize();
		}

		private function refreshContentSize():void {
			if (isNaN(width)) {
				return;
			}
			currentContent.setSize(width - 11, height - 29);
		}

		public function get isMinimalized():Boolean {
			return _isMinimalized;
		}

		public function set isMinimalized(value:Boolean):void {
			if (_isMinimalized == value || (!isSelected && !value)) {
				return;
			}
			_isMinimalized = value;
			if (value) {
				mc.removeChild(mc.body);
				currentContent.disable();
			} else {
				mc.addChild(mc.body);
				currentContent.enable();
			}
			if (cookie) {
				cookie.flush();
			}
		}

		public function get isSelected():Boolean {
			return _isSelected;
		}

		public function set isSelected(value:Boolean):void {
			if (_isSelected == value) {
				return;
			}
			_isSelected = value;
			drawIsSelected();
		}

		private function drawIsSelected():void {
			if (_isSelected) {
				container.filters = [dropShadowWhenEnabled];
				container.blendMode = BlendMode.NORMAL;
				if (canBeDeselcted) {
					removeEventSubscription(container, MouseEvent.CLICK, onHolder_Click_WhenDeselcted);
					container.mouseEnabled = false;
					container.buttonMode = false;
					container.cacheAsBitmap = false;
					container.mouseChildren = true;
					container.alpha = 1;
					isMinimalized = wasMinimalizedBeforeDeselect;
				}
			} else {
				container.filters = [];
				container.blendMode = BlendMode.SUBTRACT;
				if (canBeDeselcted) {
					addEventSubscription(container, MouseEvent.CLICK, onHolder_Click_WhenDeselcted);
					container.mouseEnabled = true;
					container.buttonMode = true;
					container.cacheAsBitmap = true;
					container.mouseChildren = false;
					container.alpha = .2;
					wasMinimalizedBeforeDeselect = isMinimalized;
					isMinimalized = true;
				}
			}
		}

		override public function dispose():void {
			currentContent.disable();
			mc.body.content.removeChild(currentContent.container);

			// bodyBorderBitmap.bitmapData.dispose();
			// bodyBorderBitmap = null;
			// upBgBitmap.bitmapData.dispose();
			// upBgBitmap = null;
			btnClose.dispose();
			btnClose = null;
			btnHistoryBack.dispose();
			btnHistoryBack = null;
			btnHistoryFront.dispose();
			btnHistoryFront = null;
			btnCorner.dispose();
			btnCorner = null;
			btnUpBg.dispose();
			btnUpBg = null;
			// for(var v:* in dictProvider_Content) {
			// dictProvider_Content[v].dispose();
			// }
			dictProvider_Content = null;
			currentContent = null;
			history.dispose();
			if (cookie) {
				cookie.dispose();
				cookie = null;
			}
			super.dispose();
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onBtnCorner_DragMove(event:ButtonEvent):void {
			setSize(btnCornerPressWidth + btnCorner.stageMoveX, btnCornerPressHeight + btnCorner.stageMoveY);
		}

		private function onBtnCorner_Press(event:ButtonEvent):void {
			btnCornerPressWidth = width;
			btnCornerPressHeight = height;
		}

		private function onBtnCorner_Release(event:ButtonEvent):void {
			if (cookie) {
				cookie.flush();
			}
		}

		private function onHolder_Click_WhenDeselcted(event:MouseEvent):void {
			dispatchEvent(new SelectEvent(SelectEvent.SELECT_REQUEST));
		}

		private function onBtnUpBg_DragMove(event:ButtonEvent):void {
			display.cacheAsBitmap = true;
			display.x = Math.round(btnUpBgPressX + btnUpBg.stageMoveX);
			display.y = Math.round(btnUpBgPressY + btnUpBg.stageMoveY);
		}

		private function onBtnUpBg_Release(event:ButtonEvent):void {
			display.cacheAsBitmap = false;
			if (cookie) {
				cookie.flush();
			}
		}

		private function onBtnUpBg_Press(event:ButtonEvent):void {
			btnUpBgPressX = display.x;
			btnUpBgPressY = display.y;
		}

		private function onBtnUpBg_DoubleCick(event:MouseEvent):void {
			isMinimalized = !isMinimalized;
		}

		private function onMC_RollOver(event:MouseEvent):void {
			_isOvered = true;
		}

		private function onMC_RollOut(event:MouseEvent):void {
			_isOvered = false;
		}

		private function onHistory_Change(event:Event):void {
			setProvider(history.getCurrentHistoryStepID(), false);
		}

		private function onBtnHistoryFront_Click(event:MouseEvent):void {
			history.forward();
		}

		private function onBtnHistoryBack_Click(event:MouseEvent):void {
			history.back();
		}

		private function onBtnClose_Click(event:MouseEvent):void {
			dispose();
		}
	}
}
import pl.brun.lib.display.tools.Slice9BitmapData;

import flash.display.BitmapData;
import flash.display.MovieClip;

internal class SliceProvider {
	private static var instance:SliceProvider;
	private var bodySliceProvider:Slice9BitmapData;
	private var beamSliceProvider:Slice9BitmapData;

	public function SliceProvider(mc_body:MovieClip, mc_beam:MovieClip) {
		bodySliceProvider = Slice9BitmapData.createFromSlicedMC(mc_body);
		beamSliceProvider = Slice9BitmapData.createFromSlicedMC(mc_beam);
	}

	public function getBGBitmapData(width:Number, height:Number):BitmapData {
		return bodySliceProvider.getScaled9BitmapData(width, height);
	}

	public function getBeamBitmapData(width:Number):BitmapData {
		return beamSliceProvider.getScaled9BitmapData(width, beamSliceProvider.getBaseHeight());
	}

	public function getMinWidth():Number {
		return bodySliceProvider.getMinWidthWithoutSmashing();
	}

	public function getMinHeight():Number {
		return bodySliceProvider.getMinHeightWithoutSmashing() + beamSliceProvider.getBaseHeight();
	}

	public static function isInitialized():Boolean {
		return Boolean(instance);
	}
}