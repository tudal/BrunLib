package pl.brun.lib.display {
	import pl.brun.lib.Base;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * Can be used as substitute when theres no filters with gpu mode enabled
	 * 
	 * @author Marek Brun
	 */
	public class BitmapFilters extends Base {
		private static var dictMCToInstance:Dictionary = new Dictionary(true);
		private var mc:DisplayObjectContainer;
		private var box0:Sprite;
		private var box:Sprite;
		private var baseBD:BitmapData;
		private var bmp:Bitmap;
		private var filterBD:BitmapData;
		private static var point0:Point = new Point();
		public static var marg:Number = 20

		public function BitmapFilters(d:DisplayObjectContainer) {
			this.mc = d
			box0 = new Sprite()
			box = new Sprite()
			box0.addChild(box)
			mc.addChild(box0)
			var i:uint;
			for (i = 0;i < mc.numChildren;i++) {
				try {
					box.addChild(mc.getChildAt(i))
				} catch(e:Error) {
				}
			}

			var globalScale:Number = DisplayUtils.getGlobalScale(mc)
			box.scaleX = box.scaleY = globalScale

			var bounds:Rectangle = box0.getBounds(mc)
			baseBD = new BitmapData(bounds.width + 1 + marg * 2, bounds.height + 1 + marg * 2, true, 0);
			baseBD.draw(box0, new Matrix(1, 0, 0, 1, -bounds.x + marg, -bounds.y + marg), null, null, null, true);

			bmp = new Bitmap(baseBD)
			bmp.smoothing = true
			bmp.x -= marg / globalScale
			bmp.y -= marg / globalScale
			bmp.x += bounds.x / globalScale
			bmp.y += bounds.y / globalScale

			box.scaleX = box.scaleY = 1
			bmp.scaleY = bmp.scaleX = 1 / globalScale

			mc.removeChild(box0)
			mc.addChild(bmp)
		}

		public function set filters(arr:Array):void {
			if (filterBD) {
				filterBD.dispose()
				filterBD = null
			}
			if (arr && arr.length) {
				filterBD = baseBD.clone()
				for each (var filter:BitmapFilter in arr) {
					filterBD.applyFilter(filterBD, filterBD.rect, point0, filter)
				}
				bmp.bitmapData = filterBD
			} else {
				bmp.bitmapData = baseBD
			}
			bmp.smoothing = true
		}

		public static function forr(display:DisplayObjectContainer):BitmapFilters {
			if (!dictMCToInstance[display]) {
				dictMCToInstance[display] = new BitmapFilters(display)
			}
			return dictMCToInstance[display]
		}
	}
}
