package pl.brun.lib.actions.controllers {
	import flash.utils.clearTimeout;
	import pl.brun.lib.actions.Action;

	import flash.utils.setTimeout;

	/**
	 * created:2011-03-03  13:37:16
	 * @author Marek Brun
	 */
	public class RandomActionsStart extends Action {

		public var minTime:uint = 100
		public var maxTime:uint = 300
		private var actions:Array/*of Action*/;
		private var toStart:Array/*of Action*/;
		private var startNextTimeoutID:uint;

		public function RandomActionsStart(actions:Array/*of Action*/, isStart:Boolean=true) {
			this.actions = actions;
		}

		override protected function doRunning():void {
			toStart = actions.concat()
			startNext()
		}

		private function startNext():void {
			if(!isRunning){
				return
			}
			Action(toStart.pop()).start()
			if(toStart.length){
				startNextTimeoutID = setTimeout(startNext, minTime + Math.random() * (maxTime - minTime))
			}else{
				finish()
			}
		}

		override protected function doIdle():void {
			if(toStart.length){
				clearTimeout(startNextTimeoutID)
			}
		}
		
	}
}
