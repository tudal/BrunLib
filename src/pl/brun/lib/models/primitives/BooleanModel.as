package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * created:2010-09-23  13:37:38
	 * @author Marek Brun
	 */
	public class BooleanModel extends ChangeModel {
		private var _value:Boolean;
		private var _iniValue:Boolean;

		public function BooleanModel(iniValue:Boolean) {
			_value = iniValue;
			_iniValue = iniValue
		}

		public function switchh():void {
			value = !value
		}

		public function get value():Boolean {
			return _value;
		}

		public function set value(value:Boolean):void {
			if (_value === value) {
				return;
			}
			_value = value;
			change()
		}

		public function get iniValue():Boolean {
			return _iniValue;
		}

		override public function export():Object {
			return {v:value}
		}

		override public function importt(obj:Object):void {
			if (!obj) return;
			value = obj.v
			change()
		}
	}
}
