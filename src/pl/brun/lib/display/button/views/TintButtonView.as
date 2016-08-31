package pl.brun.lib.display.button.views {
	import pl.brun.lib.util.DisplayUtils;
	import flash.display.DisplayObject;
	import pl.brun.lib.display.button.views.AbstractButtonView;

	/**
	 * @author Jaroslaw Zolnowski
	 */
	public class TintButtonView extends AbstractButtonView {
		private var display:DisplayObject;
		private var tint:uint;

		public function TintButtonView(tint:uint, display:DisplayObject) {
			this.tint = tint;
			this.display = display;
		}
		
		
		override protected function doRollOver():void {
			DisplayUtils.tint(display, tint)
		}
			
		override protected function doRollOut():void {
			DisplayUtils.untint(display)
		}
	}
}
