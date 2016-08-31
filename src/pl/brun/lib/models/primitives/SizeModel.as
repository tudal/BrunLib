package pl.brun.lib.models.primitives {
	import pl.brun.lib.models.ChangeModel;
	import pl.brun.lib.models.IResizable;

	/**
	 * @author Marek Brun
	 */
	public class SizeModel extends ChangeModel implements IResizable {

		private var _width:Number;
		private var _height:Number;

		public function SizeModel(iniWidth:Number = 100, iniHeight:Number = 100) {
			_width = Math.max(0, iniWidth)
			_height = Math.max(0, iniHeight)
		}

		public function get width():Number {
			return _width;
		}

		public function set width(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (value < 0) value = 0;
			if (_width == value) return;
			_width = value
			change()
		}

		public function get height():Number {
			return _height;
		}

		public function set height(value:Number):void {
			if (isNaN(value)) throw new ArgumentError("Value cant be NaN");
			if (value < 0) value = 0;
			if (_height == value) return;
			_height = value;
			change()
		}

		public function setSize(width:Number, height:Number):void {
			width = Math.max(0, width)
			height = Math.max(0, height)
			if (width == _width && height == _height) return;
			_width = width
			_height = height
			change()
		}

		override public function toString():String {
			return 'width:' + width + ' height:' + height
		}
	}
}
