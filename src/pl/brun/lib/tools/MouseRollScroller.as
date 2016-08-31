package pl.brun.lib.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.models.IScroller;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="positionRequest", type="pl.brun.lib.events.PositionEvent")]

	/**
	 * created:2010-09-23  17:26:18
	 * @author Marek Brun
	 */
	public class MouseRollScroller extends Base implements IScroller {

		private var area:Sprite;
		private var position:Number;
		private var bounds:Rectangle;

		public function MouseRollScroller(area:Sprite) {
			this.area = area;
			area.addEventListener(MouseEvent.ROLL_OVER, onArea_RollOver);
			bounds = area.getBounds(area);
		}

		public function setScroll(position:Number, visibleArea:Number, totalArea:Number):void {
			this.position = position;
		}
		
		public function getScroll():Number {
			return position;
		}

		////////////////////////////////////////////////////////////////////////
		private function onArea_RollOver(event:MouseEvent):void {
			area.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onArea_MouseWhell);
			area.stage.addEventListener(MouseEvent.MOUSE_MOVE, onArea_MouseMove);			area.mouseEnabled = false;
			area.mouseChildren = false;		}

		private function onArea_MouseWhell(event:MouseEvent):void {
			dbg.log('whell');
			var newPosition:Number = position - event.delta / 30;
			newPosition = Math.max(0, Math.min(1, newPosition));
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_REQUEST, newPosition));
		}

		private function onArea_MouseMove(event:MouseEvent):void {
			if(!bounds.contains(area.mouseX, area.mouseY)) {
				area.mouseEnabled = true;
				area.mouseChildren = true;
				if(area.stage) {
					area.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onArea_MouseWhell);
					area.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onArea_MouseMove);
				}
			}
		}
	}
}
