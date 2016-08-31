package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * created:2010-09-23  13:37:38
	 * @author Marek Brun
	 */
	public class UintModel extends ChangeModel {

		private var _value:uint;

		public function UintModel(iniValue:uint) {
			this._value = iniValue
		}

		public function get value():uint {
			return _value
		}

		public function set value(value:uint):void {
			if(_value === value) return;			_value = value
			change()
		}

		override public function export():Object {
			return {v:value}
		}

		override public function importt(obj:Object):void {
			if(!obj) return;
			value = obj.v
			change()
		}
	}
}
