package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * created:2010-09-23  13:37:38
	 * @author Marek Brun
	 */
	public class StringModel extends ChangeModel {

		private var _str:String;

		public function StringModel(str:String) {
			_str = str;
		}

		public function get value():String {
			return _str;
		}

		public function set value(value:String):void {
			if (_str === value) {
				return;
			}
			_str = value;
			change()
		}

		public function setValue(value:String):void {
			this.value = value
		}

		override public function export():Object {
			return {v:value}
		}

		override public function importt(obj:Object):void {
			if (!obj || !obj.v) return;
			value = obj.v
		}
	}
}
