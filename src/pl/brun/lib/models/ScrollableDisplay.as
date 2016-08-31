package pl.brun.lib.models {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class ScrollableDisplay extends Base implements IScrollable {

		private var lengthName:String = 'height';		private var axisName:String = 'y';
		private var display:DisplayObject;
		private var _maskBounds:Rectangle;		private var lastScroll:Number = 0;

		public function ScrollableDisplay(display:DisplayObject, maskBounds:Rectangle, isYAxis:Boolean = true) {
			if(!isYAxis) {
				lengthName = 'width';				axisName = 'x';
			}
			this._maskBounds = maskBounds;
			this.display = display;
			FrameDelayCall.addCall(refresh);
		}

		public function refresh():void {
			setScroll(lastScroll)
		}

		public function get maskBounds():Rectangle {
			return _maskBounds;
		}

		public function set maskBounds(value:Rectangle):void {
			_maskBounds = value;
		}

		public function getScroll():Number {
			var bounds:Rectangle = display.getBounds(display.parent);
			var rest:Number = bounds[lengthName] - _maskBounds[lengthName];
			if(rest <= 0) {
				return 0;
			}
			var scroll:Number = (_maskBounds[axisName] - bounds[axisName]) / rest;
			scroll = Math.max(0, Math.min(1, scroll));
			return scroll;
		}

		public function setScroll(scroll:Number):void {
			var bounds:Rectangle = display.getBounds(display.parent);
			var rest:Number = bounds[lengthName] - _maskBounds[lengthName];
			var displayToBoundsDiff:Number = bounds[axisName] - display[axisName];
			if(rest < 0) {
				display[axisName] = _maskBounds[axisName] - displayToBoundsDiff; 
			} else {
				display[axisName] = _maskBounds[axisName] - rest * scroll - displayToBoundsDiff;
			}
			lastScroll = getScroll();
			dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGED, lastScroll));
		}

		public function getVisibleArea():Number {
			return _maskBounds[lengthName];
		}

		public function getTotalArea():Number {
			return display[lengthName];
		}
	}
}
