package pl.brun.lib.debugger.display {
	import flash.text.TextFieldAutoSize;

	import pl.brun.lib.debugger.model.FPSMeter;
	import pl.brun.lib.display.DisplayBase;

	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * @author Marek Brun
	 */
	public class FPSMeterView extends DisplayBase {
		private var model:FPSMeter;
		private var tf:TextField;
		private var refreshTimer:Timer;

		public function FPSMeterView() {
			tf = new TextField()
			tf.width = 80
			tf.multiline = false
			tf.filters = [new GlowFilter(0xFFFFFF, 1, 2, 2, 9, 1)]
			tf.autoSize = TextFieldAutoSize.LEFT

			container.addChild(tf)

			model = new FPSMeter()
			refreshTimer = new Timer(100)
			refreshTimer.addEventListener(TimerEvent.TIMER, onRefreshTimer_Timer)
			refreshTimer.start()
		}

		private function onRefreshTimer_Timer(event:TimerEvent):void {
			tf.text = ' ' + model.getFPS().toFixed(2)
		}
	}
}
