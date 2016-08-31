package pl.brun.lib.models.primitives {
	import flash.events.Event;

	import pl.brun.lib.models.ChangeModel;

	/**
	 * @author Marek Brun
	 */
	public class RangeWithMinMaxModel extends ChangeModel {
		private var _min:NumberModel;
		private var _max:NumberModel;
		private var _range:RangeModel;
		private var _position:NumberModel;
		private var isPositionChange:Boolean;

		public function RangeWithMinMaxModel(from:Number, to:Number, min:Number, max:Number) {
			_range = new RangeModel(from, to)
			_min = new NumberModel(min)
			_max = new NumberModel(max)
			_position = new NumberModel((getRightPerc() + getLeftPerc()) / 2)
			_position.addEventListener(Event.CHANGE, onPosition_Change)
			addChangeChild(_range, 'range')
			addChangeChild(_min, 'min')
			addChangeChild(_max, 'max')
		}

		private function onPosition_Change(event:Event):void {
			isPositionChange = true
			var len:Number = getLength()
			var midLen:Number = getMidLengthPerc() * len
			var pos:Number = position.value
			var positionValue:Number = pos * (len - midLen)
			range.from = min.value + positionValue
			range.to = min.value + positionValue + midLen
			isPositionChange = false
		}

		override protected function changed():void {
			if (!isPositionChange) {
				_position.removeEventListener(Event.CHANGE, onPosition_Change)
				_position.value = (getRightPerc() + getLeftPerc()) / 2
				_position.addEventListener(Event.CHANGE, onPosition_Change)
			}
		}

		public function get min():NumberModel {
			return _min;
		}

		public function get max():NumberModel {
			return _max;
		}

		public function get range():RangeModel {
			return _range;
		}

		public function getLeftPerc():Number {
			var form:Number = range.from - min.value
			return form / getLength()
		}

		public function getRightPerc():Number {
			var to:Number = range.to - min.value
			return to / getLength()
		}

		public function getMidLengthPerc():Number {
			return Math.max(0, (range.to - range.from) / getLength())
		}

		public function getLength():Number {
			return max.value - min.value
		}

		override public function toString():String {
			return min.value.toFixed(2) + '| ' + range.from.toFixed(2) + ' - ' + range.to.toFixed(2) + ' |' + max.value.toFixed(2)
		}

		public function get position():NumberModel {
			return _position;
		}
	}
}
