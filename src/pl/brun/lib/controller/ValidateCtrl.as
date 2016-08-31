package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.IEnablable;
	import pl.brun.lib.models.IValidatable;

	import flash.events.Event;

	/**
	 * created:2010-10-01  13:27:51
	 * @author Marek Brun
	 */
	public class ValidateCtrl extends Base {

		private var fields:Array;
		private var sendButton:IEnablable;

		public function ValidateCtrl(fields:Array/*of IValidatable*/, sendButton:IEnablable) {
			this.fields = fields;
			this.sendButton = sendButton;
			
			var i:uint;
			var field:IValidatable;
			for(i = 0;i < fields.length;i++) {
				field = fields[i];
				field.addEventListener(Event.CHANGE, onField_Change);
			}
			
			drawValid();
		}

		private function drawValid():void {
			if(isValid()) {
				sendButton.enable();
			}else{
				sendButton.disable();
			}
		}
		
		private function isValid():Boolean {
			var i:uint;
			var field:IValidatable;
			for(i = 0;i < fields.length;i++) {
				field = fields[i];
				if(!field.isValid()){
					return false;
				}
			}
			return true;
		}
		
		////////////////////////////////////////////////////////////////////////
		private function onField_Change(event:Event):void {
			drawValid();
		}
	}
}
