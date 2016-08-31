package pl.brun.lib.display.displayObjects {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class TestBackground extends Sprite {

		private var bd:BitmapData;

		public function TestBackground(rectSize:uint = 20, color1:uint = 0xFFFFFF, color2:uint = 0xD5D5D5) {
			bd = new BitmapData(rectSize * 2, rectSize * 2, false, color1);
			bd.fillRect(new Rectangle(0, 0, rectSize, rectSize), color2);
			bd.fillRect(new Rectangle(rectSize, rectSize, rectSize, rectSize), color2);
		}

		public function dispose():void {
			bd.dispose();
			bd = null;
			graphics.clear();
		}

		public function draw(width:Number, height:Number):void {
			graphics.clear();
			graphics.beginBitmapFill(bd, null, true, false);
			graphics.moveTo(0, 0);
			graphics.lineTo(width, 0);
			graphics.lineTo(width, height);
			graphics.lineTo(0, height);
			graphics.lineTo(0, 0);
		}
	}
}
