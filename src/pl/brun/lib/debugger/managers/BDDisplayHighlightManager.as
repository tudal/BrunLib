package pl.brun.lib.debugger.managers {
	import pl.brun.lib.debugger.display.BDDisplayHighlighter;
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.events.EventPlus;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public class BDDisplayHighlightManager extends DisplayBase {

		private var dictDisplay_Highlighter:Dictionary = new Dictionary(true);

		public function BDDisplayHighlightManager() {
		}

		public function getHighlightByDisplay(display:DisplayObject):BDDisplayHighlighter {
			if(!dictDisplay_Highlighter[display]) {
				dictDisplay_Highlighter[display] = new BDDisplayHighlighter(display);
				var highlighter:BDDisplayHighlighter = dictDisplay_Highlighter[display];
				addEventSubscription(highlighter, EventPlus.BEFORE_DISPOSED, onHighlighter_BeforeDisposed);
				container.addChild(highlighter.container);
			}
			return dictDisplay_Highlighter[display]; 
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onHighlighter_BeforeDisposed(event:EventPlus):void {
			var highlighter:BDDisplayHighlighter = BDDisplayHighlighter(event.target);
			delete dictDisplay_Highlighter[highlighter.displayToHighlight];
			container.removeChild(highlighter.container);
		}
	}
}
