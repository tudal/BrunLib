package pl.brun.lib.test.animation.dynamic_ {
	import pl.brun.lib.animation.dynamic_.AnimatedInertialNumber;
	import pl.brun.lib.animation.dynamic_.AnimatedStoppingNumber;
	import pl.brun.lib.test.TestBase;

	import flash.events.MouseEvent;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class AnimatedNumberTest extends TestBase {

		private var mc:AnimationClassTestMC;
		private var animToAX:AnimatedInertialNumber;
		private var animToAY:AnimatedInertialNumber;
		private var animToBX:AnimatedStoppingNumber;
		private var animToBY:AnimatedStoppingNumber;

		public function AnimatedNumberTest() {
			mc = new AnimationClassTestMC();
			holder.addChild(mc);
			
			animToAX = new AnimatedInertialNumber();
			animToAX.target = mc.a.x;			animToAX.addAutoMapping(mc.ball, 'x', true);
			
			animToAY = new AnimatedInertialNumber();
			animToAY.target = mc.a.y;			animToAY.addAutoMapping(mc.ball, 'y', true);
			
			animToBX = new AnimatedStoppingNumber();
			animToBX.target = mc.b.x;
			animToBX.addAutoMapping(mc.ball, 'x', true);
			
			animToBY = new AnimatedStoppingNumber();
			animToBY.target = mc.b.y;
			animToBY.addAutoMapping(mc.ball, 'y', true);
			
			mc.btnAnimToA.addEventListener(MouseEvent.CLICK, onBtnAnimToA_Click);
			mc.btnAnimToB.addEventListener(MouseEvent.CLICK, onBtnAnimToB_Click);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onBtnAnimToB_Click(event:MouseEvent):void {
			animToBX.start();
			animToBY.start();
		}

		private function onBtnAnimToA_Click(event:MouseEvent):void {
			animToAX.start();
			animToAY.start();
		}
	}
}
