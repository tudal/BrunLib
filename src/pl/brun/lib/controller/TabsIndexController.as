package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.util.ArrayUtils;

	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.text.TextField;

	/**
	 * @author Marek Brun
	 */
	public class TabsIndexController extends Base {

		private var objects:Array/*of InteractiveObject*/;

		public function TabsIndexController(objects:Array/*of InteractiveObject*/) {
			setObejcts(objects)
		}

		public function setObejcts(objects:Array):void {
			if (this.objects) {
				var i:uint;
				var obj:InteractiveObject;
				for (i = 0;i < this.objects.length;i++) {
					obj = this.objects[i]
					obj.removeEventListener(FocusEvent.FOCUS_IN, onObjFocusIn)
					obj.removeEventListener(FocusEvent.FOCUS_OUT, onObjFocusOut)
				}
			}
			this.objects = objects
			for (i = 0;i < objects.length;i++) {
				obj = objects[i];
				obj.tabEnabled = true;
				obj.addEventListener(FocusEvent.FOCUS_IN, onObjFocusIn, false, 0, true)
				obj.addEventListener(FocusEvent.FOCUS_OUT, onObjFocusOut, false, 0, true)
			}
		}

		protected function onObjFocusIn(event:FocusEvent):void {
			var focused:InteractiveObject = InteractiveObject(event.target);
			var next:InteractiveObject = InteractiveObject(ArrayUtils.getNextByValue(objects, focused));
			var i:uint;
			var loop:InteractiveObject;
			for (i = 0;i < objects.length;i++) {
				loop = objects[i];
				loop.tabIndex = 99;
			}
			focused.tabIndex = 100;
			next.tabIndex = 101;
			if (focused is TextField) {
				TextField(focused).scrollH = 0;
				TextField(focused).setSelection(TextField(focused).length, TextField(focused).length);
			}
		}

		protected function onObjFocusOut(event:FocusEvent):void {
			var focused:InteractiveObject = InteractiveObject(event.target);
			if (focused is TextField) {
				TextField(focused).scrollH = 0;
				TextField(focused).setSelection(TextField(focused).length, TextField(focused).length);
			}
		}
	}
}
