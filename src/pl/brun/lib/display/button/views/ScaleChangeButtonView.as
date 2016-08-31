package pl.brun.lib.display.button.views {
	import pl.brun.lib.animation.static_.Animation;
	import pl.brun.lib.models.easing.Bezier3Easing;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.util.func.delayCall2;

	import flash.display.DisplayObject;

	/**
	 * 2011-03-22  17:44:46
	 * @author Marek Brun
	 */
	public class ScaleChangeButtonView extends OverOutActionsButtonView {
		private var over:Animation;
		private var out:Animation;

		public function ScaleChangeButtonView(display:DisplayObject, targetScale:Number, timeOver:uint = 250, timeOut:uint = 400, easing:Easing = null) {
			var over:Animation = new Animation(timeOver)
			super(over, out, false)
			this.over = over
			
			if(!easing) {
				easing = new Bezier3Easing()
			}
			
			over.addProperty(display, "scaleX", targetScale, easing)
		}

		override protected function doRollOut():void {
			delayCall2(this, doRollOut2, 4)
		}

		private function doRollOut2():void {
			if(!isOver) {
				super.doRollOut()
			}
		}
	}
}