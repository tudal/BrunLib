package pl.brun.lib.display.button.views {
	import flash.display.DisplayObject;

	/**
	 * @author Marek Brun
	 */
	public class SwapToTopButtonView extends AbstractButtonView {
		
		private var display:DisplayObject;

		public function SwapToTopButtonView(display:DisplayObject) {
			this.display = display;
		}

		override protected function doRollOver():void {
			if(display.parent){
				display.parent.addChild(display);	
			}
		}
		
	}
}
