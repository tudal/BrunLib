package pl.brun.lib.display.button.views {
	import pl.brun.lib.actions.Action;

	/**
	 * 2011-03-22  17:30:26
	 * @author Marek Brun
	 */
	public class OverOutActionsButtonView extends AbstractButtonView {

		private var over:Action;
		private var out:Action;
		private var rootAction:Action;

		public function OverOutActionsButtonView(over:Action, out:Action, mustFinish:Boolean) {
			this.out = out
			this.over = over
			if(mustFinish){
				rootAction = new Action()
				rootAction.addChildAction(out)				rootAction.addChildAction(over)
			}
		}

		override protected function doRollOver():void {
			over.start()
		}

		override protected function doRollOut():void {
			out.start()
		}
	}
}
