package pl.brun.lib.test.util.func {
	import flash.display.Sprite;
	/**
	 * @author Marek Brun
	 */
	public function drawX(display:Sprite):void {
		display.graphics.clear()
		display.graphics.lineStyle(0, 0xFF0000)
		display.graphics.moveTo(0, -10)
		display.graphics.lineTo(0, 10)
		display.graphics.lineTo(10, 0)
		display.graphics.lineTo(-10, 0)
	}
}
