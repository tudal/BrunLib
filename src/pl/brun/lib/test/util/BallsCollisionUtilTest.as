package pl.brun.lib.test.util {
	import flash.utils.getTimer;
	import brunlib_assets_fla.BallsCollisionMC;

	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.BallsCollisionUtils;

	import flash.events.MouseEvent;

	/**
	 * @author Marek Brun
	 */
	public class BallsCollisionUtilTest extends TestBase {
		private var mc:BallsCollisionMC;

		override protected function init():void {
			super.init()
			mc = new BallsCollisionMC()
			centerHolder.addChild(mc)
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove)
		}

		private function onMouseMove(event:MouseEvent):void {
			mc.b1.x = mc.mouseX
			mc.b1.y = mc.mouseY

			var t:int = getTimer()
			var ball0AB:Object = BallsCollisionUtils.getAB(mc.a.x, mc.a.y, mc.a1.x, mc.a1.y, true)
			var ball1AB:Object = BallsCollisionUtils.getAB(mc.b.x, mc.b.y, mc.b1.x, mc.b1.y, true)
			var coll:Array = BallsCollisionUtils.getRealTimeBallsColl(ball0AB, ball1AB, mc.b.width)
			dbg.logv("t", getTimer()-t)
			if (coll) {
				mc.a2.x = coll[0].x
				mc.a2.y = coll[0].y
				mc.b2.x = coll[1].x
				mc.b2.y = coll[1].y
				mc.a2.visible = true
				mc.b2.visible = true
			} else {
				mc.a2.visible = false
				mc.b2.visible = false
			}
		}
	}
}
