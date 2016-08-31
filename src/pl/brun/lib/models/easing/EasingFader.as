package pl.brun.lib.models.easing {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	public class EasingFader extends Easing {
		public var fixPrecision:uint = 3;
		private var base:Easing;
		private var _fade:Number = 0;
		private var dictLogToNum:Dictionary = new Dictionary();
		private var isFreshReverse:Boolean;

		public function EasingFader(base:Easing) {
			this.base = base;
			refreshReverseEasing()
		}

		public function getReverseEasing(easing:Number):Number {
			var id:String = easing.toFixed(fixPrecision)
			if (isNaN(dictLogToNum[id])) throw new IllegalOperationError("No reverse easing for number " + easing + " id " + id);
			return dictLogToNum[id]
		}

		override protected function calculateEasing(input:Number):Number {
			var num:Number = base.getEasing(input)
			return input + (num - input) * fade
		}

		public function get fade():Number {
			return _fade;
		}

		public function set fade(value:Number):void {
			if (_fade == value) return;
			isFreshReverse = false
			_fade = value
		}

		public function refreshReverseEasing():void {
			if (isFreshReverse) return;
			isFreshReverse = true
			var i:uint
			for (i = 0;i < 10001;i++) {
				dictLogToNum[getEasing(i / 10000).toFixed(fixPrecision)] = i / 10000
			}
			dictLogToNum[(0).toFixed(fixPrecision)] = 0
			dictLogToNum[(1).toFixed(fixPrecision)] = 1
		}
	}
}
