package pl.brun.lib.display.ui {
	import pl.brun.lib.display.button.SpriteButton;
	import pl.brun.lib.models.primitives.BooleanModel;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * created:2010-09-23  14:09:33
	 * @author Marek Brun
	 */
	public class RadioButton extends SpriteButton {

		private var mc:MovieClip;
		private var model:BooleanModel;

		/**
		 * @param mc : 1st frame-false, 2nd frame-true
		 */
		public function RadioButton(mc:MovieClip, model:BooleanModel) {
			super(mc);
			this.mc = mc;
			this.model = model;
			
			model.addEventListener(Event.CHANGE, onModel_Change);
			
			draw();
		}

		override protected function doPress():void {
			super.doPress();
			model.value = true;
		}

		private function draw():void {
			mc.gotoAndStop(1 + int(model.value));
		}

		////////////////////////////////////////////////////////////////////////
		private function onModel_Change(event:Event):void {
			draw();
		}
	}
}
