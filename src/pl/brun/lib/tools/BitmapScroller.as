package pl.brun.lib.tools {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BitmapData;

	import pl.brun.lib.Base;

	/**
	 * @author Marek Brun
	 */
	public class BitmapScroller extends Base {
		public var source:BitmapData;
		private var _scrollY:Number = 0;
		private var _scrollX:Number = 0;
		private var width:Number;
		private var height:Number;
		private var bd:BitmapData;
		private var lastPosX:int;
		private var lastPosY:int;

		public function BitmapScroller(source:BitmapData, width:Number, height:Number) {
			source.height
			this.height = height;
			this.width = width;
			this.source = source;
			bd = new BitmapData(width, height, true, 0)
			bd.draw(source)
		}

		public function reset():void {
			bd.draw(source)
			_scrollX = 0
			_scrollX = 0
		}

		public function set scrollY(value:Number):void {
			_scrollY = Math.max(0, Math.min(1, value))
			var pos:int = value * (source.height - height)
			var moveY:int = pos - lastPosY
			var sourceRect:Rectangle
			var destPoint:Point
			bd.scroll(0, -moveY)
			if (moveY > 0) {
				sourceRect = new Rectangle(0, pos + height - moveY, width, moveY)
				destPoint = new Point(0, height - moveY)
				bd.copyPixels(source, sourceRect, destPoint)
			} else {
				sourceRect = new Rectangle(0, pos, width, -moveY)
				destPoint = new Point(0, 0)
				bd.copyPixels(source, sourceRect, destPoint)
			}
			lastPosY = pos
		}

		public function get scrollY():Number {
			return _scrollY;
		}

		public function set scrollX(value:Number):void {
			_scrollX = Math.max(0, Math.min(1, value))
			var pos:int = value * (source.width - width)
			var moveX:int = pos - lastPosX
			var sourceRect:Rectangle
			var destPoint:Point
			bd.scroll(-moveX, 0)
			if (moveX > 0) {
				sourceRect = new Rectangle(pos + width - moveX, 0, moveX, height)
				destPoint = new Point(width - moveX, 0)
				bd.copyPixels(source, sourceRect, destPoint)
			} else {
				sourceRect = new Rectangle(pos, 0, -moveX, height)
				destPoint = new Point(0, 0)
				bd.copyPixels(source, sourceRect, destPoint)
			}
			lastPosX = pos
		}

		public function get scrollX():Number {
			return _scrollX;
		}

		public function get bitmapData():BitmapData {
			return bd;
		}

		override public function dispose():void {
			bd.dispose()
			bd = null
			super.dispose()
		}
	}
}
