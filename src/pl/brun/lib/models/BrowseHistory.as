package pl.brun.lib.models {
	import pl.brun.lib.Base;

	import flash.events.Event;

	/**
	 * Events:
	 *  - Event.CHANGE
	 * 
	 * @author Marek Brun
	 */
	public class BrowseHistory extends Base {

		private var history:Array;
		private var backCount:uint;

		public function BrowseHistory() {
			history = [];
			backCount = 0;
		}

		public function add(historyStepID:*):void {
			history.splice(history.length - backCount);
			history.push(historyStepID);
			backCount = 0;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function back():void {
			if(!getCanGoBack()) { 
				return; 
			}
			backCount++;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function forward():void {
			if(!getCanGoForward()) { 
				return; 
			}
			backCount--;
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getCanGoForward():Boolean {
			return backCount > 0;
		}

		public function getCanGoBack():Boolean {
			return Boolean(history[history.length - 1 - backCount - 1]);
		}

		public function getCurrentHistoryStepID():* {
			return history[history.length - 1 - backCount];
		}
	}
}
