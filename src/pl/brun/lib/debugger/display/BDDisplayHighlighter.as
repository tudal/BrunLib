package pl.brun.lib.debugger.display {
	import pl.brun.lib.debugger.model.IBDEnable;
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getTimer;

	/**
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public class BDDisplayHighlighter extends DisplayBase implements IBDEnable {

		private var _isEnabled:Boolean;
		private var _displayToHighlight:DisplayObject;
		private var startTime:int;
		private var xMark:BFLA_xMarkMC;
		private var tf:TextField;
		private var holder2:Sprite;
		private var box:Sprite;

		public function BDDisplayHighlighter(displayToHighlight:DisplayObject) {
			_displayToHighlight = displayToHighlight;
			holder2 = new Sprite();
			
			xMark = new BFLA_xMarkMC();
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = 'x';
			tf.y = -tf.height;
			tf.background = true;
			box = new Sprite();
			box.blendMode = BlendMode.INVERT;
			
			holder2.addChild(tf);			holder2.addChild(xMark);			holder2.addChild(box);
		}

		private function getNameWithParents():String {
			var patch:Array = DisplayUtils.getPatch(displayToHighlight);
			patch[patch.length - 1] = '<b>' + patch[patch.length - 1] + '</b>';
			return patch.join('.');
		}

		public function get isEnabled():Boolean {
			return _isEnabled;
		}

		public function set isEnabled(value:Boolean):void {
			if(_isEnabled == value) {
				return;
			}
			_isEnabled = value;			if(value) {
				startTime = getTimer();
				container.addChild(holder2);				addEventSubscription(displayToHighlight, Event.ENTER_FRAME, onDisplayToHighlight_EnterFrame);
			} else {				container.removeChild(holder2);
				removeEventSubscription(displayToHighlight, Event.ENTER_FRAME, onDisplayToHighlight_EnterFrame);				
			}
		}

		public function get displayToHighlight():DisplayObject {
			return _displayToHighlight;
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onDisplayToHighlight_EnterFrame(event:Event):void {
			var time:uint = getTimer() - startTime;
			if(displayToHighlight.stage && container.stage) {
				holder2.visible = true;
				
				tf.htmlText = getNameWithParents();
				
				var obj:Point = new Point(0, 0);
				obj = displayToHighlight.localToGlobal(obj);
				obj = container.parent.globalToLocal(obj);
				container.x = obj.x;				container.y = obj.y;
				
				xMark.alpha = Boolean(int(time / 500) % 2) ? 0.2 : 1;
				
				var bounds:Rectangle = displayToHighlight.getBounds(container);
				box.graphics.clear();
				box.graphics.lineStyle(0, 0xFF0000);				box.graphics.moveTo(0, 0);
				box.graphics.lineTo(bounds.x, bounds.y);				box.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			} else {				holder2.visible = false;
			}
		}
	}
}
