package pl.brun.lib.test.animation {
	import pl.brun.lib.display.DisplayBase;

	import flash.events.Event;
	import flash.text.TextFieldAutoSize;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class PropertySlider extends DisplayBase {

		private var mc:PropertySliderMC;
		private var obj:Object;
		private var prop:String;

		public function PropertySlider(mc:PropertySliderMC, obj:Object, prop:String, min:Number, max:Number) {
			super(mc);
			this.prop = prop;
			this.obj = obj;
			this.mc = mc;
			
			mc.tfLabel.autoSize = TextFieldAutoSize.RIGHT;
			
			mc.slider.addEventListener(Event.CHANGE, onSlider_Change);
			mc.slider.maximum = max;
			mc.slider.minimum = min;
			mc.slider.liveDragging = true;
			mc.slider.snapInterval = 0.01;			mc.slider.value = obj[prop];
			
			drawLabel();
		}

		private function drawLabel():void {
			mc.tfLabel.text = prop + ' : ' + obj[prop];
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onSlider_Change(event:Event):void {
			obj[prop] = mc.slider.value;
			drawLabel();
		}
	}
}
