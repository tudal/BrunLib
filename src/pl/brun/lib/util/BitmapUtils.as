package pl.brun.lib.util {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class BitmapUtils {
		public static function getBitmapDataByBigDisplay(display:DisplayObject, onbitmap:BitmapData = null, tileSize:uint = 4000):BitmapData {
			var bounds:Rectangle = display.getBounds(display);
			if (!onbitmap) {
				if (bounds.width > 8191) {
					throw new ArgumentError("Passed display object width is bigger than limit (" + bounds.width + " limit:8,191)");
				}
				if (bounds.height > 8191) {
					throw new ArgumentError("Passed display object height is bigger than limit (" + bounds.height + " limit:8,191)");
				}
				var size:Number = bounds.width * bounds.height;
				if (size > 16777215) {
					throw new ArgumentError("Passed display object pixels count is bigger than limit (" + size + " limit:16,777,215)");
				}
				onbitmap = new BitmapData(bounds.width + 1, bounds.height + 1, true, 0);
			}

			var scrollRectOrg:Rectangle = display.scrollRect;
			var scrollRect:Rectangle = new Rectangle();
			scrollRect.width = tileSize;
			scrollRect.height = tileSize;

			var tile:BitmapData = new BitmapData(tileSize, tileSize, true, 0);

			var sourceRect:Rectangle = new Rectangle(0, 0, tileSize, tileSize);
			var fillRect:Rectangle = new Rectangle(0, 0, tileSize, tileSize);

			var x:uint;
			var y:uint;
			for (x = 0;x < onbitmap.width / tileSize + 1;x++) {
				for (y = 0;y < onbitmap.height / tileSize + 1;y++) {
					scrollRect.x = bounds.x + x * tileSize;
					scrollRect.y = bounds.y + y * tileSize;
					display.scrollRect = scrollRect;

					tile.fillRect(fillRect, 0x00000000);
					tile.draw(display);
					onbitmap.merge(tile, sourceRect, new Point(x * tileSize, y * tileSize), 0xFF, 0xFF, 0xFF, 0xFF);
				}
			}

			tile.dispose();
			display.scrollRect = scrollRectOrg;

			return onbitmap;
		}

		public static function getBitmapDataByDisplay(display:DisplayObject, onbitmap:BitmapData = null):BitmapData {
			var bounds:Rectangle = display.getBounds(display);
			if (!onbitmap) {
				bounds.width = Math.min(bounds.width, 4050);
				bounds.height = Math.min(bounds.height, 4050);
				onbitmap = onbitmap = new BitmapData(bounds.width + 1, bounds.height + 1, true, 0);
			}
			onbitmap.draw(display, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y), null, null, null, true);

			return onbitmap;
		}

		public static function getBitmapByDisplay(display:DisplayObject, isRescale:Boolean = false):Bitmap {
			var bmp:Bitmap = new Bitmap(getBitmapDataByDisplay(display), "auto", true);
			if (isRescale) {
				bmp.width = display.width;
				bmp.height = display.height;
			}
			return bmp;
		}

		public static function getColorFromCenter(display:DisplayObject):Number {
			var bounds:Rectangle = display.getBounds(display);
			return getColorFromPoint(display, new Point(int(bounds.x + bounds.width / 2), int(bounds.y + bounds.height / 2)));
		}

		public static function getColorFromPoint(display:DisplayObject, point:Point):Number {
			var bd:BitmapData = new BitmapData(display.width, display.height);
			bd.draw(display);
			var color:Number = bd.getPixel(point.x, point.y);
			bd.dispose();
			return color;
		}

		public static function getBitmapDataByDisplayParent(display:DisplayObject):BitmapData {
			var gotParent:Boolean = Boolean(display.parent);
			if (gotParent) {
				var orgParent:DisplayObjectContainer = display.parent;
				var orgIndex:uint = display.parent.getChildIndex(display);
			}
			var sprite:Sprite = new Sprite();
			sprite.addChild(display);
			var bd:BitmapData = getBitmapDataByDisplay(sprite);
			if (gotParent) {
				orgParent.addChildAt(display, orgIndex);
			} else {
				sprite.removeChild(display);
			}
			return bd;
		}

		public static function mergeBitmapWithExactFit(bitmapPasteIn:BitmapData, bitmapToPaste:BitmapData, x:Number, y:Number, width:Number = NaN, height:Number = NaN):void {
			height = isNaN(height) ? bitmapToPaste.height : Math.round(height);
			width = isNaN(width) ? bitmapToPaste.width : Math.round(width);
			if (!width || !height) {
				return;
			}
			var matrix:Matrix = new Matrix();
			matrix.scale(width / bitmapToPaste.width, height / bitmapToPaste.height);
			var transformedBitmapToPaste:BitmapData = new BitmapData(width, height, true, 0x00000000);
			transformedBitmapToPaste.draw(bitmapToPaste, matrix, null, null, new Rectangle(0, 0, width, height), false);

			bitmapPasteIn.merge(transformedBitmapToPaste, new Rectangle(0, 0, width, height), new Point(Math.round(x), Math.round(y)), 0xFF, 0xFF, 0xFF, 0xFF);

			transformedBitmapToPaste.dispose();
		}

		public static function clear(bd:BitmapData):void {
			bd.fillRect(new Rectangle(0, 0, bd.width, bd.height), 0x00FFFFFF);
		}
	}
}
