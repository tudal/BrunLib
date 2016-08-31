package pl.brun.lib.display.button {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class AreaButton extends ButtonModel {
		private var mouseSource:Sprite;
		private var area:Rectangle;
		private var pressX:Number;
		private var pressY:Number;

		public function AreaButton(mouseSource:Sprite, area:Rectangle) {
			this.area = area;
			this.mouseSource = mouseSource;
			if (mouseSource.stage) {
				addEventSubscription(mouseSource.stage, MouseEvent.MOUSE_MOVE, onStage_MouseMove_whileAdded)
			}
			addEventSubscription(mouseSource, Event.ADDED_TO_STAGE, onMouseSource_AddedToStage)
			addEventSubscription(mouseSource, Event.REMOVED_FROM_STAGE, onMouseSource_RemovedFromStage)
		}

		public function setArea(area:Rectangle):void {
			this.area = area
			if (mouseSource.stage) {
				checkMouse()
			}
		}

		private function checkMouse():void {
			var mx:Number = mouseSource.mouseX
			var my:Number = mouseSource.mouseY
			if (isEnabled) {
				if (isOver) {
					if (!area.contains(mx, my)) {
						rollOut()
					}
				} else {
					if (area.contains(mx, my)) {
						rollOver()
					}
				}
			}
		}

		override protected function doOver():void {
			addEventSubscription(stage, MouseEvent.MOUSE_DOWN, onStage_MouseDown_WhileOver)
		}

		override protected function doOut():void {
			removeEventSubscription(stage, MouseEvent.MOUSE_DOWN, onStage_MouseDown_WhileOver)
		}

		private function onStage_MouseDown_WhileOver(event:MouseEvent):void {
			press()
		}

		override protected function doPress():void {
			pressX = mouseSource.mouseX
			pressY = mouseSource.mouseY
			addEventSubscription(stage, MouseEvent.MOUSE_UP, onStage_MouseUp_WhilePressed)
		}

		public function dragX():Number {
			return mouseSource.mouseX - pressX
		}

		public function dragY():Number {
			return mouseSource.mouseY - pressY
		}

		private function onStage_MouseUp_WhilePressed(event:MouseEvent):void {
			removeEventSubscription(stage, MouseEvent.MOUSE_UP, onStage_MouseUp_WhilePressed)
			release()
		}

		private function onStage_MouseMove_whileAdded(event:MouseEvent):void {
			checkMouse()
		}

		private function onMouseSource_RemovedFromStage(event:Event):void {
			removeEventSubscription(mouseSource.stage, MouseEvent.MOUSE_MOVE, onStage_MouseMove_whileAdded)
		}

		private function onMouseSource_AddedToStage(event:Event):void {
			addEventSubscription(mouseSource.stage, MouseEvent.MOUSE_MOVE, onStage_MouseMove_whileAdded)
		}

		override public function dispose():void {
			if (isOver) {
				rollOut()
			}
			super.dispose()
		}
	}
}
