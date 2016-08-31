package pl.brun.lib.managers {
	import flash.utils.getTimer;

	import pl.brun.lib.debugger.GlobalDbg;

	/**
	 * @author Marek Brun
	 */
	public class CurrentTime {

		static private var instance:CurrentTime;
		private var currentTime:Number;
		private var lastGetTimer:Number;
		private var dateTmp:Date;

		public function CurrentTime(currentTime:Number) {
			setTime(currentTime)
			dateTmp = new Date()
		}

		public function setTime(currentTime:Number):void {
			this.currentTime = currentTime
			lastGetTimer = getTimer()
		}

		public static function time():Number {
			return instance.time_()
		}

		private function time_():Number {
			currentTime += getTimer() - lastGetTimer
			lastGetTimer = getTimer()
			dateTmp.time = currentTime
			GlobalDbg.d.logv('  time', dateTmp)
			return currentTime
		}

		static public function ins():CurrentTime {
			if (instance) {
				return instance;
			} else {
				throw new Error('Before call ServertimeProvider.getInstance() you should call ServertimeProvider.init()');
			}
		}

		/**
		 * @param currenttime - unixtime
		 */
		static public function init(currentTime:Number, updateToSys:Boolean = false):void {
			if (instance) {
				instance.setTime(currentTime)
			} else {
				instance = new CurrentTime(currentTime);
			}
		}
	}
}
internal class Private {
}