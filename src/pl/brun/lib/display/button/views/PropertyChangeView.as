package pl.brun.lib.display.button.views {
	/**
	 * @author Marek Brun
	 */
	public class PropertyChangeView extends AbstractButtonView {

		private var over:Number;
		private var out:Number;
		private var obj:Object;
		private var property:String;

		public function PropertyChangeView(obj:Object, property:String, out:Number, over:Number) {
			this.property = property
			this.obj = obj
			this.out = out
			this.over = over
			obj[property] = out
		}

		override protected function doRollOver():void {
			obj[property] = over
		}

		override protected function doRollOut():void {
			obj[property] = out
		}
	}
}
