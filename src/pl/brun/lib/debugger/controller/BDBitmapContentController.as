package pl.brun.lib.debugger.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.display.content.BDBitmapContent;
	import pl.brun.lib.debugger.model.content.BDDisplayObjectBitmapModel;

	import flash.events.MouseEvent;

	/**
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public class BDBitmapContentController extends Base {

		private var bitmapper:BDDisplayObjectBitmapModel;
		private var bitmapperView:BDBitmapContent;

		public function BDBitmapContentController(model:BDDisplayObjectBitmapModel, view:BDBitmapContent) {
			this.bitmapperView = view;
			this.bitmapper = model;
			
			addEventSubscription(bitmapperView, MouseEvent.CLICK, onBitmapperView_Click);
			drawBitmapInfo();
		}

		private function drawBitmapInfo():void {
			if(bitmapper.isParentbitmapMode) {
				bitmapperView.setInfo('parent view');
			} else {
				bitmapperView.setInfo('self view');
			}
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onBitmapperView_Click(event:MouseEvent):void {
			bitmapper.isParentbitmapMode = !bitmapper.isParentbitmapMode;
			drawBitmapInfo();
		}
	}
}
