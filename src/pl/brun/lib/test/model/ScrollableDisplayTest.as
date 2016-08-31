package pl.brun.lib.test.model {
	import pl.brun.lib.controller.ScrollController;
	import pl.brun.lib.display.ui.scroller.Scroller;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.models.ScrollableDisplay;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;

	/**
	 * @author Marek Brun
	 */
	public class ScrollableDisplayTest extends TestBase {

		private var scrollableDisplay:ScrollableDisplay;
		private var mc:ScrollableDisplayTestMC;
		private var scroller:Scroller;
		private var scrollController:ScrollController;
		
		override protected function init():void {
			super.init()
			
			mc = new ScrollableDisplayTestMC();
			addChild(mc);
			mc.x = 400;			mc.y = 400;
			
			scrollableDisplay = new ScrollableDisplay(mc.scrolledRect, mc.rectMask.getBounds(mc));
			scroller = new Scroller(mc.scroller);
			scrollController = new ScrollController(scrollableDisplay, scroller);
			
			scroller.addEventListener(PositionEvent.POSITION_CHANGED, onScroller_PositionChanged);
			
			dbg.log('scrollableDisplay.getScroll():' + dbg.link(scrollableDisplay.getScroll()));
			
			addTestKey(KeyCode.R, resizeRect, null, 'resizeRect();');			addTestKey(KeyCode.Y, resizeRectAndChangeY, null, 'resizeRectAndChangeY();');			addTestKey(KeyCode.X, resizeRectAndChangeInsideXY, null, 'resizeRectAndChangeInsideXY();');
		}

		private function resizeRect():void {
			mc.scrolledRect.scaleY = Math.random();
			scrollableDisplay.refresh();
		}

		private function resizeRectAndChangeY():void {
			mc.scrolledRect.scaleY = Math.random();
			mc.scrolledRect.y = Math.random() * stage.stageHeight;
			scrollableDisplay.refresh();
		}

		private function resizeRectAndChangeInsideXY():void {
			mc.scrolledRect.scaleY = Math.random();
			mc.scrolledRect.rect.y = -100 + Math.random() * 200;			mc.scrolledRect.rect.x = -100 + Math.random() * 200;
			scrollableDisplay.refresh();
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onScroller_PositionChanged(event:PositionEvent):void {
			dbg.log('scrollableDisplay.getScroll():' + dbg.link(scrollableDisplay.getScroll()));
		}
	}
}
