package pl.brun.lib.display.tools {
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * Store data about rasterizing at class level.
	 * @author Marek Brun
	 */
	public class RasterizeInfo {
		public var className:String;
		public var bitmaps:Array /*of BitmapData*/ 
		= [];
		public var bounds:Array /*of Rectangle*/ 
		= [];
		public var gotAllFramesBitmaps:Boolean;
		public var countRasterizedFrames:uint;
		private var totalFrames:uint;

		public function RasterizeInfo(className:String, totalFrames:uint) {
			this.className = className;
			this.totalFrames = totalFrames;
		}

		/**
		 * If there's alredy bitmap for that frame method returns false
		 */
		public function getGotFrameData(frame:uint):Boolean {
			return bitmaps[frame];
		}

		public function setFrameData(frame:uint, bd:BitmapData, bounds:Rectangle):void {
			bitmaps[frame] = bd;
			this.bounds[frame] = bounds;
			countRasterizedFrames++;
			if (countRasterizedFrames >= totalFrames) {
				gotAllFramesBitmaps = true;
			}
		}

		public function dispose():void {
			for each (var bd:BitmapData in bitmaps) bd.dispose();
			bitmaps = null
			bounds = null
		}
	}
}

