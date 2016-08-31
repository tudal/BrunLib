package pl.brun.lib.models {
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.tools.BitmapScroller;
	import pl.brun.lib.Base;

	import flash.display.BitmapData;

	/**
	 * @author Marek Brun
	 */
	public class ScrollableBitmap extends Base implements IScrollable {
		
		public var scroller:BitmapScroller;
		private var source:BitmapData;
		private var height:Number;

		public function ScrollableBitmap(source:BitmapData, width:Number, height:Number) {
			scroller = new BitmapScroller(source, width, height)
			this.height = height
			this.source = source
			addDisposeChild(scroller)
		}

		public function getScroll():Number {
			return scroller.scrollY;
		}

		public function setScroll(scroll:Number):void {
			scroller.scrollY = scroll
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, scroll))
		}

		public function getVisibleArea():Number {
			return height;
		}

		public function getTotalArea():Number {
			return source.height;
		}

		public function get bitmapData():BitmapData {
			return scroller.bitmapData;
		}
	}
}
