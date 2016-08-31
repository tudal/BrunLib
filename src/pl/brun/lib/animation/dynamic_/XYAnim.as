package pl.brun.lib.animation.dynamic_ {
	import pl.brun.lib.actions.tools.MultiActions;

	import flash.display.DisplayObject;

	/**
	 * created:2011-03-02  11:07:07
	 * @author Marek Brun
	 */
	public class XYAnim extends MultiActions {

		private var display:DisplayObject;
		private var xAnim:AnimatedStoppingNumber;
		private var yAnim:AnimatedStoppingNumber;

		public function XYAnim(display:DisplayObject, isAutoStart:Boolean=false) {
			super([]);
			this.display = display;
			xAnim = new AnimatedStoppingNumber()
			xAnim.addAutoMapping(display, 'x')
			xAnim.isAutoStart = isAutoStart
			targetX = display.x			addAction(xAnim)
			yAnim = new AnimatedStoppingNumber()
			yAnim.addAutoMapping(display, 'y')
			yAnim.isAutoStart = isAutoStart
			targetY = display.y
			addAction(yAnim)
		}

		public function set targetX(value:Number):void {
			xAnim.target = value
		}

		public function set targetY(value:Number):void {
			yAnim.target = value
		}
		
		public function set speed(value:Number):void {
			xAnim.speed = value;			yAnim.speed = value;
		}
		
		public function set minDistToTarget(value:Number):void {
			xAnim.minDistToTarget = value;
			yAnim.minDistToTarget = value;
		}

		public function cancel():void {
			xAnim.cancel()			yAnim.cancel()
		}
	}
}
