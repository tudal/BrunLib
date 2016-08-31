package pl.brun.lib.display {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.IArrangeable;

	import flash.display.DisplayObject;

	[Event(name="lengthChanged", type="pl.brun.lib.events.EventPlus")]
	/**
	 * @author Marek Brun
	 */
	public class DisplayArrange extends Base implements IArrangeable {

		private var display:DisplayObject;
		private var positionName:String;
		private var lengthName:String;
		private var shortnessName:String;
		private var shortnessPositionName:String;

		public function DisplayArrange(display:DisplayObject, isXAxis:Boolean) {
			this.display = display
			positionName = isXAxis ? 'x' : 'y'
			lengthName = isXAxis ? 'width' : 'height'
			shortnessName = isXAxis ? 'height' : 'width'
			shortnessPositionName = isXAxis ? 'y' : 'x'
		}

		public function get position():Number {
			return display[positionName]
		}

		public function get length():Number {
			return display[lengthName]
		}

		public function set position(value:Number):void {
			if (display[positionName] == value) {
				return
			}
			display[positionName] = value
			// dispatchEvent(new EventPlus(EventPlus.LENGTH_CHANGED))
		}

		public static function createArray(displays:Array/*of DisplayObject*/, isXAxis:Boolean):Array/*of DisplayArrange*/
 		{
			var arr:Array /*of DisplayArrange*/ 
			= []
			var i:uint
			var display:DisplayObject
			for (i = 0;i < displays.length;i++) {
				display = displays[i]
				arr.push(new DisplayArrange(display, isXAxis))
			}
			return arr
		}

		public function get shortness():Number {
			return display[shortnessName];
		}

		public function get shortPosition():Number {
			return display[shortnessPositionName];
		}

		public function set shortPosition(value:Number):void {
			display[shortnessPositionName] = value
		}
	}
}
