package pl.brun.lib.debugger.display.content {
	import pl.brun.lib.debugger.model.content.IBDContentProvider;
	import pl.brun.lib.display.BitmapProviderEvent;
	import pl.brun.lib.display.displayObjects.TestBackground;
	import pl.brun.lib.models.IBitmapProvider;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * Events:
	 *  - MouseEvent.CLICK
	 * 
	 * created: 2009-12-25
	 * @author Marek Brun
	 */
	public class BDBitmapContent extends BDAbstractContent {

		private var bitmap:Bitmap;
		private var bg:TestBackground;
		private var bitmapProvider:IBitmapProvider;
		private var tfInfo:TextField;

		public function BDBitmapContent(label:String, contentProvider:IBDContentProvider, bitmapProvider:IBitmapProvider) {
			super(label, contentProvider);
			
			tfInfo = new TextField();
			tfInfo.background = true;
			tfInfo.autoSize = TextFieldAutoSize.LEFT;
			bitmap = new Bitmap();
			bg = new TestBackground();
			container.addChild(bg);
			container.addChild(bitmap);			container.addChild(tfInfo);
			
			container.addEventListener(MouseEvent.CLICK, onHolder_Click);
			
			this.bitmapProvider = bitmapProvider;
		}

		public function setInfo(info:String):void {
			tfInfo.text = info;
		}

		private function draw():void {
			if(bitmapProvider.gotBitmap()) {
				bitmap.bitmapData = bitmapProvider.getBitmap();
			} else {
				bitmap.bitmapData = null;
			}
		}

		override protected function enable():void {
			addEventSubscription(bitmapProvider, BitmapProviderEvent.NEW_BITMAP, onBitmapProvider_NewBitmap);
			draw();
		}

		override protected function disable():void {
			removeEventSubscription(bitmapProvider, BitmapProviderEvent.NEW_BITMAP, onBitmapProvider_NewBitmap);
		}

		override protected function refreshSize():void {
			bg.draw(width, height);
			tfInfo.y = height - tfInfo.height;
		}

		override public function dispose():void {
			bg.dispose();
			bg = null;
			super.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onBitmapProvider_NewBitmap(event:BitmapProviderEvent):void {
			draw();
		}

		private function onHolder_Click(event:MouseEvent):void {
			dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
}
