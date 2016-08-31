package pl.brun.lib.display.button.views {
	import pl.brun.lib.actions.Action;

	/**
	 * @author Marek Brun
	 */
	public class OverActionButtonView extends AbstractButtonView {

		private var overAction:Action;

		public function OverActionButtonView(overAction:Action) {
			this.overAction = overAction;
		}

		override protected function doRollOver():void {
			overAction.start();
		}

		override protected function doRollOut():void {
			overAction.finish();
		}
	}
}
