package pl.brun.lib.debugger.display.content {
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.profiler.BDProfiler;

	import flash.events.TextEvent;
	import flash.system.System;

	/**
	 * @author Marek Brun
	 */
	public class BDProfilerTextContent extends BDTextContent {

		private var profiler:BDProfiler;

		public function BDProfilerTextContent(label:String, model:BDProfiler, links:BDTextsManager) {
			profiler = model;
			super(label, model, links);
		}
		
		override protected function init():void {
			if(!isInit){
				super.init();
				mc.tf.addEventListener(TextEvent.LINK, onTF_Link);
				mc.tf.scrollV = 0;
			}
		}

		override protected function getText():String {
			var text:String = '';
			if(profiler.isRunning) {
				text += '<a href="event:turnoff">turn off</a>';
			} else {
				text += '<a href="event:turnon">turn on</a>';
			}
			if(profiler.isRunning) {
				text += '	<a href="event:clear">clear</a>';
			}
			
			text += '	<a href="event:gc">force garbage collector</a>';
			
			return text + '\n\n' + super.getText();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onTF_Link(event:TextEvent):void {
			switch(event.text) {
				case 'turnoff':
					profiler.isRunning = false;
					draw();
					break;
				case 'turnon':
					profiler.isRunning = true;
					draw();
					break;
				case 'clear':					profiler.clear();					draw();
					break;
				case 'gc':
					System.gc();
					break;
			}
		}
	}
}
