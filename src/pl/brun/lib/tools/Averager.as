package pl.brun.lib.tools {
	import pl.brun.lib.Base

	public class Averager extends Base {

		public var lengthLimit:uint
		private var history:Array
		private var sum:Number
		private var average:Number
		private var isNewAverage:Boolean

		public function Averager(lengthLimit:uint = 15) {
			this.lengthLimit = lengthLimit
			clear()
		}

		public function push(num:Number):void {
			history.push(num)
			sum += num
			while(history.length > lengthLimit) {
				sum -= Number(history.shift())
			}
			isNewAverage = false
		}

		public function getAverage():Number {
			if(!isNewAverage) { 
				average = sum / history.length 
				isNewAverage = true 
			}
			return average
		}

		public function getAddedRecently():Number {
			return history[history.length - 1]
		}

		public function clear():void {
			history = []
			sum = 0
			isNewAverage = true
			average = 1
		}
	}
}