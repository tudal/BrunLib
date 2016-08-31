package pl.brun.lib.display.button.views {
	import pl.brun.lib.animation.dynamic_.AnimatedStoppingNumber;

	/**
	 * @author Marek Brun
	 */
	public class PropertyAnimChangeView extends AbstractButtonView {

		private var over:Number;
		private var out:Number;
		private var obj:Object;
		private var property:String;
		private var anim:AnimatedStoppingNumber;

		public function PropertyAnimChangeView(obj:Object, property:String, out:Number, over:Number, animSpeed:Number = 0.3) {
			this.property = property
			this.obj = obj
			this.out = out
			this.over = over
			obj[property] = out
			anim = new AnimatedStoppingNumber(out)
			anim.addAutoMapping(obj, property)
			anim.speed = animSpeed
		}

		override protected function doRollOver():void {
			anim.target = over
		}

		override protected function doRollOut():void {
			anim.target = out
		}
	}
}
