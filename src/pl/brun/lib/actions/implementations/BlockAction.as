package pl.brun.lib.actions.implementations {
	import pl.brun.lib.actions.Action;
	/**
	 * created: 2010-01-18
	 * @author Marek Brun
	 */
	public class BlockAction extends Action {

		//public var isStartBlocked2:Boolean;		public var isFinishBlocked:Boolean = true;

		public function BlockAction() {
		}

		override protected function canBeStarted():Boolean {
			return !isStartBlocked;
		}

		override protected function canBeFinished():Boolean {
			return !isFinishBlocked;
		}
		
	}
}
