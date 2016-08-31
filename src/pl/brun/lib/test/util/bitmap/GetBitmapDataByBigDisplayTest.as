package pl.brun.lib.test.util.bitmap {
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.BitmapUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class GetBitmapDataByBigDisplayTest extends TestBase {

		private var longMC:LongImgMC;
		private var longMCAsBitmap:BitmapData;
		private var bitmap:Bitmap;
		private var longMCAsBitmapNormal:BitmapData;
		private var bitmapNormal:Bitmap;

		public function GetBitmapDataByBigDisplayTest() {
			longMC = new LongImgMC();
			dbg.log('bigMC.width:' + dbg.link(longMC.width));
			dbg.log('bigMC.height:' + dbg.link(longMC.height));
			
			//MovieClip on top
			longMC.width = 400;
			longMC.scaleY = longMC.scaleX;
			var bounds:Rectangle = longMC.getBounds(this);
			longMC.x=-bounds.x;			longMC.y=-bounds.y;
			addChild(longMC);
			
			//bad bitmap on middle
			longMCAsBitmapNormal = BitmapUtils.getBitmapDataByDisplay(longMC);
			
			bitmapNormal = new Bitmap();
			bitmapNormal.bitmapData = longMCAsBitmapNormal;
			bitmapNormal.scaleY = bitmapNormal.scaleX = longMC.scaleX;
			bitmapNormal.y = longMC.y + longMC.height + 40;
			addChild(bitmapNormal);
			
			//ok bitmap on bottom			longMCAsBitmap = BitmapUtils.getBitmapDataByBigDisplay(longMC);
			
			bitmap = new Bitmap();
			bitmap.bitmapData = longMCAsBitmap;
			bitmap.scaleY = bitmap.scaleX = longMC.scaleX;
			bitmap.y = bitmapNormal.y + bitmapNormal.height + 40;
			addChild(bitmap);
		}
	}
}
