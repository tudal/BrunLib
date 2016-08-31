package pl.brun.lib.controller {
	import flash.events.Event;

	import pl.brun.lib.Base;
	import pl.brun.lib.models.IResizable;
	import pl.brun.lib.models.primitives.SizeModel;

	/**
	 * 13-02-2014
	 * @author Marek Brun
	 */
	public class ResizeBySizeCtrl extends Base {

		private var resizable:IResizable;
		private var size:SizeModel;

		public function ResizeBySizeCtrl(size:SizeModel, resizable:IResizable) {
			this.size = size;
			this.resizable = resizable;

			resizable.setSize(size.width, size.height)
			
			addEventSubscription(size, Event.CHANGE, onSize_Change)
		}

		private function onSize_Change(event:Event):void {
			resizable.setSize(size.width, size.height)
		}
	}
}
