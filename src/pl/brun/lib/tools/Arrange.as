package pl.brun.lib.tools {
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import pl.brun.lib.Base;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.models.IArrangeable;

	[Event(name="lengthChanged", type="pl.brun.lib.events.EventPlus")]
	/**
	 * @author Marek Brun
	 */
	public class Arrange extends Base implements IArrangeable {

		private var arrangables:Array/*of IArrangeable*/=[];
		private var marg:Number;
		public var initPos:Number = 0;
		private var lastLength:Number = 0;
		private var _shortness:Number = 0;
		private var dictArra_MargToNext:Dictionary = new Dictionary();
		/** -1: left, 0:center, 1:right */
		public var shortnessAlign:int = -1
		public var shortnessInitPos:Number = 0

		public function Arrange(arrangables:Array/*of IArrangeable*/, marg:Number = 0, getExtraMargins:Boolean = true) {
			this.marg = marg
			var i:uint
			var arrangable:IArrangeable
			for (i = 0;i < arrangables.length;i++) {
				arrangable = arrangables[i]
				addArrangable(arrangable)
			}

			if (getExtraMargins && arrangables.length > 0) {
				var nextArrangable:IArrangeable
				var margToNext:Number
				for (i = 0;i < arrangables.length - 1;i++) {
					arrangable = arrangables[i]
					nextArrangable = arrangables[i + 1]
					margToNext = nextArrangable.position - (arrangable.position + arrangable.length)
					dictArra_MargToNext[arrangable] = margToNext
				}
			}

			drawNow()
		}

		public function addArrangable(arrangable:IArrangeable):void {
			if (arrangables.length == 0) initPos = arrangable.position;
			arrangables.push(arrangable)
			arrangable.addEventListener(EventPlus.LENGTH_CHANGED, onArrangable_LengthChanged)
			dictArra_MargToNext[arrangable] = 0
			draw()
		}

		public function get position():Number {
			return initPos
		}

		public function set position(value:Number):void {
			if (initPos == value) {
				return
			}
			initPos = value
			draw()
		}

		public function get length():Number {
			return lastLength;
		}

		public function get shortness():Number {
			return _shortness;
		}

		public function draw():void {
			//if (!CallOncePerFrame.call(draw)) return;
			drawNow()
		}

		public function drawNow():void {
			if (arrangables.length == 0) return;
			var i:uint
			var arrangable:IArrangeable
			var currPos:Number = initPos;
			_shortness = 0
			for (i = 0;i < arrangables.length;i++) {
				arrangable = arrangables[i]
				arrangable.position = currPos
				currPos += arrangable.length + marg + dictArra_MargToNext[arrangable]
				_shortness = Math.max(arrangable.shortness, _shortness)
				
				if (shortnessAlign == -1) {
					arrangable.shortPosition = shortnessInitPos
				} else if (shortnessAlign == 0) {
					arrangable.shortPosition = shortnessInitPos - arrangable.shortness/2
				} else if (shortnessAlign == 1) {
					arrangable.shortPosition = shortnessInitPos - arrangable.shortness
				}else{
					throw new IllegalOperationError("unsupported shortPosition:")
				}
			}
			var newLength:Number = currPos - marg
			if (newLength != lastLength) {
				lastLength = newLength
				dispatchEvent(new EventPlus(EventPlus.LENGTH_CHANGED))
			}
		}

		private function onArrangable_LengthChanged(event:EventPlus):void {
			draw()
		}

		public function get shortPosition():Number {
			return 0;
		}

		public function set shortPosition(value:Number):void {
			throw new IllegalOperationError('?')
		}
	}
}
