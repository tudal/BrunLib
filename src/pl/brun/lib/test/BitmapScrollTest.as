package pl.brun.lib.test {

	/**
	 * @author Marek Brun
	 */
	public class BitmapScrollTest extends TestBase {
		/*private var bmp:BitmapData;
		private var bitmap:Bitmap;
		private var position:int;
		private var matrix:Matrix = new Matrix();
		private var rectangle:Rectangle = new Rectangle();
		private var gfxBmp:BitmapData;
		private var btnAll:SpriteButton;
		private var bmpHolder:Sprite;
		private var bitmapGfx:Bitmap;

		public function BitmapScrollTest() {
			super(true, false, 120);
			FPS.init(this);
			
			var gfx:StreetMC = new StreetMC();
			
			gfxBmp = getBitmapDataByDisplay(gfx);
			
			bmp = new BitmapData(600, 340, true);
			
			bmpHolder = new Sprite();
			addChild(bmpHolder);
			
			bitmap = new Bitmap();
			bitmap.bitmapData = bmp;
			
			bmpHolder.addChild(bitmap);
			
			btnAll = new SpriteButton(bmpHolder);
			btnAll.addEventListener(ButtonEvent.DRAG_MOVE, onBtnAll_DragMove);
			
			bmp.draw(gfxBmp);
			
			bitmapGfx = new Bitmap();
			bitmapGfx.bitmapData = gfxBmp;
			bitmapGfx.y = bmp.height + 10;
			bitmapGfx.scaleX = bitmapGfx.scaleY = 0.2;
			addChild(bitmapGfx);
		}

		private function scroll(dist:int):void {
			var lastPosition:int = position;
			position += dist;
			dist = position - lastPosition;
			
			if(dist > 0) {
				rectangle.x = bmp.width - dist;
				rectangle.width = dist;
			} else {
				rectangle.x = 0;
				rectangle.width = -dist;
			}
			rectangle.y = 0;
			rectangle.height = bmp.height;
			
			matrix.tx = -position;
			
			bmp.lock();
			bmp.scroll(-dist, 0);
			bmp.draw(gfxBmp, matrix, null, null, rectangle, false);
			bmp.unlock();
		}

		public static function getBitmapDataByDisplay(display:DisplayObject, onbitmap:BitmapData = null):BitmapData {
			var bounds:Rectangle = display.getBounds(display);
			if(!onbitmap) {
				onbitmap = new BitmapData(Math.max(1, bounds.width + 1), Math.max(1, bounds.height + 1), true, 0);
			}
			//onbitmap.draw(display, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y), null, null, null, true);

			var scrollRect:Rectangle = new Rectangle();
			scrollRect.x = bounds.width / 2;			scrollRect.width = bounds.width / 2;			scrollRect.height = bounds.height;
			display.scrollRect = scrollRect;
			
			var secondHalfRect:Rectangle = new Rectangle(onbitmap.width/4, 0, onbitmap.width / 2, onbitmap.height);
			onbitmap.draw(display, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y), null, null, secondHalfRect, true);
			
			return onbitmap;
		}
		

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onBtnAll_DragMove(event:ButtonEvent):void {
			scroll(btnAll.dragMoveX);
		}*/
		
	}
}
