package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;

	/**
	 * @author Marek Brun
	 */
	public class RangeModel extends ChangeModel {

		private var _from:Number;
		private var _to:Number;
		private var _diff:Number;
		private var _isLog:Boolean;
		private var minv:Number;
		private var maxv:Number;
		private var scale:Number;

		public function RangeModel(iniFrom:Number, iniTo:Number) {
			_from = iniFrom
			_to = iniTo
			_diff = _to - _from
			precalculateLog()
		}

		public function getPosition(value:Number):Number {
			if (isLog) {
				return logPosition(value)
			}
			return (value - _from) / _diff
		}

		public function getByPosition(position:Number):Number {
			if (isLog) {
				return logSlider(position)
			}
			return _from + _diff * position
		}

		public function get from():Number {
			return _from;
		}

		public function set from(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (_from == value) return;
			_from = value
			_diff = _to - _from
			precalculateLog()
			change()
		}

		public function get to():Number {
			return _to;
		}

		public function set to(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (_to == value) return;
			_to = value
			_diff = _to - _from
			precalculateLog()
			change()
		}

		public function setRange(from:Number, to:Number):void {
			if (isNaN(from)) throw new ArgumentError("Value cant be NaN");
			if (isNaN(to)) throw new ArgumentError("Value cant be NaN");
			var _fromTmp:Number = _from
			var _toTmp:Number = _to
			if (_from == from && _to == to) return;
			_to = to
			_from = from
			_diff = _to - _from
			precalculateLog()
			change()
		}

		public function get range():Number {
			return _diff;
		}

		public function plus(amount:Number):void {
			_to += amount
			_from += amount
			precalculateLog()
			change()
		}

		public function logSlider(position:Number):Number {
			if (position < 0 || position == 0) {
				return 0
			}
			return Math.exp(minv + scale * position);
		}

		public function logPosition(value:Number):Number {
			if (value < 0 || value == 0) {
				return from
			}
			return (Math.log(value) - minv) / scale;
		}

		private function precalculateLog():void {
			if (from == to) {
				dbg.log('same from to - '+from)
			}
			minv = Math.log(_from)
			maxv = Math.log(_to)
			scale = maxv - minv;
		}

		public function get isLog():Boolean {
			return _isLog;
		}

		public function set isLog(isLog:Boolean):void {
			if (_isLog == isLog) return;
			_isLog = isLog;
			change()
		}

		override public function toString():String {
			return _from + '-' + _to
		}

		override public function export():Object {
			return {from:from, to:to}
		}

		override public function importt(obj:Object):void {
			_from = obj.from
			_to = obj.to
			_diff = _to - _from
			precalculateLog()
			change()
		}

		public function gotInRange(value:Number):Boolean {
			return value >= from && value <= to;
		}
	}
}
