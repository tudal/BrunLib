package pl.brun.lib.tools {
	import flash.events.Event;
	import pl.brun.lib.Base;
	import pl.brun.lib.service.FTS;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * @author Marek Brun
	 */
	public class DisplayToBMPLive extends Base {
		private var display:DisplayObject;
		private var _bitmapData:BitmapData;
		private var _fts:FTS;
		private var matrix:Matrix;

		public function DisplayToBMPLive(display:DisplayObject, width:Number, height:Number, matrix:Matrix = null, fts:FTS = null) {
			this.matrix = matrix
			this._fts = fts ? fts : new FTS()
			this.display = display
			_bitmapData = new BitmapData(width, height, true, 0)
			
			_fts.addEventListener(Event.ENTER_FRAME, onFTS_EnterFrame)
			
			snap()
		}

		public function snap():void {
			bitmapData.fillRect(bitmapData.rect, 0)
			bitmapData.draw(display, matrix)
		}

		private function onFTS_EnterFrame(event:Event):void {
			snap()
		}

		public function get bitmapData():BitmapData {
			return _bitmapData;
		}

		public function get fts():FTS {
			return _fts;
		}
	}
}
