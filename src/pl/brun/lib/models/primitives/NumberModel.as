package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;

	/**
	 * created:2010-09-23  13:37:38
	 * @author Marek Brun
	 */
	public class NumberModel extends ChangeModel {

		protected var _value:Number;
		private var _iniValue:Number;

		public function NumberModel(iniValue:Number) {
			if (isNaN(iniValue)) throw new ArgumentError("iniValue cant be NaN");
			_iniValue = iniValue
			_value = iniValue
		}

		public function get value():Number {
			return _value
		}

		public function set value(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (_value === value) return;
			_value = value
			change()
		}

		public function get iniValue():Number {
			return _iniValue;
		}

		override public function export():Object {
			return {v:value}
		}

		override public function importt(obj:Object):void {
			if (!obj) return;
			if(isNaN(obj.v)) return;
			value = obj.v
			change()
		}
	}
}
