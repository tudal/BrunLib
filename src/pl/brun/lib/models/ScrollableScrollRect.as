package pl.brun.lib.models {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.PositionEvent;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author Marek
	 */
	public class ScrollableScrollRect extends Base implements IScrollable {
		/** change this if height od display is changed */
		public var displayHeight:Number;
		private var scrollRect:Rectangle;
		private var display:DisplayObject;
		private var prevScroll:Number = 0;

		public function ScrollableScrollRect(display:DisplayObject) {
			this.display = display;
			scrollRect = display.scrollRect
			displayHeight = display.getBounds(display).height
		}

		public function setVisibleHeight(height:Number):void {
			scrollRect.height = height
			scrollRect = scrollRect.clone()
			refreshHeight()
		}

		public function refreshHeight():void {
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, getScroll()))
			setScroll(getScroll())
		}

		public function getScroll():Number {
			return Math.max(0, Math.min(1, scrollRect.y / (displayHeight - scrollRect.height)))
		}

		public function setScroll(value:Number):void {
			value = Math.max(0, Math.min(1, value))
			if (scrollRect.height > displayHeight) {
				scrollRect.y = 0
			} else {
				scrollRect.y = value * (displayHeight - scrollRect.height)
			}
			display.scrollRect = scrollRect.clone()
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, getScroll()))
		}

		public function getVisibleArea():Number {
			return scrollRect.height;
		}

		public function getTotalArea():Number {
			return displayHeight;
		}

		public function isScroll():Boolean {
			return getVisibleArea() * 1.5 < getTotalArea();
		}

		public function setHeight(height:Number):void {
			displayHeight = height
			refreshHeight()
		}

		public function get scroll():Number {
			return getScroll();
		}

		public function set scroll(value:Number):void {
			if (prevScroll < 0.85 && value > 0.98) return;
			prevScroll = value
			setScroll(value)
		}
	}
}
