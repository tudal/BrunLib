package pl.brun.lib.models.primitives {
	/**
	 * @author Marek Brun
	 */
	public class NumberRangeModel extends NumberModel {
		private var _max:Number;
		private var _min:Number;

		public function NumberRangeModel(iniValue:Number, min:Number, max:Number) {
			if (iniValue < min) {
				iniValue = min;
			}
			if (iniValue > max) {
				iniValue = max;
			}
			super(iniValue)
			if (isNaN(min)) throw new ArgumentError("Value cant be NaN");
			if (isNaN(max)) throw new ArgumentError("Value cant be NaN");
			_min = min
			_max = max
		}

		public function get range():Number {
			return _max - _min;
		}

		public function get max():Number {
			return _max;
		}

		public function set max(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (_max == value) return;
			_max = value
			this.value = this.value
			change()
		}

		public function get min():Number {
			return _min;
		}

		public function set min(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (_min == value) return;
			_min = value
			this.value = this.value
			change()
		}

		override public function set value(value:Number):void {
			super.value = Math.max(_min, Math.min(_max, value))
		}

		public function getPercValue():Number {
			return (value - min) / (max - min);
		}

		public function setValueByPerc(val:Number):void {
			value = getValueByPerc(val)
		}

		public function getValueByPerc(val:Number):Number {
			return min + (max - min) * val
		}

		public override function export():Object {
			return {v:value, min:min, max:max}
		}

		public override function importt(obj:Object):void {
			if (!obj) return;
			if (isNaN(obj.v)) return;
			value = obj.v
			change()
			/*min = obj.min
			max = obj.max*/
		}
	}
}
