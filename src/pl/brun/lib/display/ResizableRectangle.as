package pl.brun.lib.display {
	import pl.brun.lib.models.IResizable;

	/**
	 * 22-01-2014
	 * @author Marek Brun
	 */
	public class ResizableRectangle extends DisplayBase implements IResizable {
		private var color:uint;
		private var width:Number = 100;
		private var height:Number = 100;
		public var test:Boolean;

		public function ResizableRectangle(color:uint) {
			this.color = color
			draw()
		}

		public function setSize(width:Number, height:Number):void {
			this.height = height;
			this.width = width;
			draw()
		}

		private function draw():void {
			container.graphics.clear()
			if (!width || !height) {
				return
			}
			container.graphics.beginFill(color)
			container.graphics.drawRect(0, 0, width, height)
			if (test) {
				container.graphics.lineStyle(0, 0xFFFFFF / 2)
				container.graphics.moveTo(width / 2, 0)
				container.graphics.lineTo(width, height / 2)
				container.graphics.lineTo(width / 2, height)
				container.graphics.lineTo(0, height / 2)
				container.graphics.lineTo(width / 2, 0)
			}
		}
	}
}
