package pl.brun.lib.service {
	import pl.brun.lib.models.primitives.BooleanModel;
	import pl.brun.lib.Base;
	import pl.brun.lib.tools.Averager;

	import flash.events.Event;
	import flash.utils.getTimer;

	[Event(name="enterFrame", type="flash.events.Event")]
	/**
	 * @author Marek Brun
	 */
	public class FTS extends Base {
		private static var instance:FTS
		private var lastFrameTime:Number
		private var betweenFramesTimeAverager:Averager
		private var currentTime:Number
		private var frameNumber:Number
		private var _isPaused:BooleanModel;

		public function FTS() {
			_isPaused = new BooleanModel(false)
			_isPaused.addEventListener(Event.CHANGE, onIsPaused_Change)
			frameNumber = 0
			lastFrameTime = getTimer()
			betweenFramesTimeAverager = new Averager(40)
			betweenFramesTimeAverager.push(200)
			betweenFramesTimeAverager.push(200)
			currentTime = getTimer()
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
		}

		public function getLastFrameTime():Number {
			return betweenFramesTimeAverager.getAddedRecently()
		}

		public function getLastFrametimeInS01():Number {
			return betweenFramesTimeAverager.getAddedRecently() / 1000
		}

		public function getAverageFrameTime():Number {
			return betweenFramesTimeAverager.getAverage()
		}

		public function getAverageFrameTimeInS01():Number {
			return betweenFramesTimeAverager.getAverage() / 1000
		}

		public function getFPS():Number {
			return 1000 / betweenFramesTimeAverager.getAverage()
		}

		public function getTime():Number {
			return currentTime
		}

		/** @return singleton instance of FTS */
		public static function getInstance():FTS {
			if (instance == null) {
				instance = new FTS()
			}
			return instance
		}

		public function getFrameNumber():Number {
			return frameNumber
		}

		private function onStage_EnterFrame(event:Event):void {
			frameNumber++
			currentTime = getTimer()
			betweenFramesTimeAverager.push(currentTime - lastFrameTime)
			lastFrameTime = currentTime

			dispatchEvent(new Event(Event.ENTER_FRAME))
		}

		private function onIsPaused_Change(event:Event):void {
			if (_isPaused.value) {
				removeEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame)
			} else {
				lastFrameTime = currentTime = getTimer()
				addEventSubscription(root, Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true)
			}
		}

		public function get isPaused():BooleanModel {
			return _isPaused;
		}
	}
}
