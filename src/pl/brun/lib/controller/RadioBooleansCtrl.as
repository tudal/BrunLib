package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.primitives.BooleanModel;
	import pl.brun.lib.models.primitives.UintModel;

	import flash.events.Event;

	/**
	 * created:2010-09-23  13:41:37
	 * @author Marek Brun
	 */
	public class RadioBooleansCtrl extends Base {

		private var bools:Array/*of BooleanModel*/;
		private var selected:UintModel;

		public function RadioBooleansCtrl(bools:Array/*of BooleanModel*/, selected:UintModel) {
			this.selected = selected;
			this.bools = bools;
			var i:uint;
			var bool:BooleanModel;
			for(i = 0;i < bools.length;i++) {
				bool = bools[i];
				bool.addEventListener(Event.CHANGE, onBool_Change);
			}
			selected.addEventListener(Event.CHANGE, onSelected_Change);
		}

		private function onSelected_Change(event:Event):void {
			var i:uint;
			var bool:BooleanModel;
			for(i = 0;i < bools.length;i++) {
				bool = bools[i];
				bool.value = i == selected.value;
			}
		}

		private function onBool_Change(event:Event):void {
			var changedBool:BooleanModel = BooleanModel(event.target);
			if(!changedBool.value) {
				return;
			}
			selected.value = bools.indexOf(changedBool);
		}
	}
}
