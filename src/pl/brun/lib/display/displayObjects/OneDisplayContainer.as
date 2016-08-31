package pl.brun.lib.display.displayObjects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;

	[Event(name="addedChild", type="pl.brun.lib.display.displayObjects.OneDisplayContainerEvent")]

	[Event(name="removedChild", type="pl.brun.lib.display.displayObjects.OneDisplayContainerEvent")]

	/**
	 * Sprite z możliwością dodania tylko jednego dziecka (jak w Chinach :D)
	 * 
	 * @author Marek Brun
	 */
	public class OneDisplayContainer extends Sprite {
		
		private var _currentChild:DisplayObject;
		private var isAdding:Boolean;

		public function OneDisplayContainer() {
			name = 'oneDisplayContainer';
		}

		public function removeCurrentChild():void {
			if(_currentChild) {
				removeChild(_currentChild);
			}
		}

		override public function removeChild(child:DisplayObject):DisplayObject {
			if(child == _currentChild && child.parent && child.parent==this) {
				_currentChild = null;
				if(!isAdding) {
					dispatchEvent(new OneDisplayContainerEvent(OneDisplayContainerEvent.REMOVED_CHILD));
				}
				return super.removeChild(child);
			}
			return null;
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			if(child == _currentChild) {
				return child;
			}
			isAdding = true;
			var oldDisplay:DisplayObject = _currentChild;
			removeCurrentChild();
			_currentChild = child;
			isAdding = false;
			if(!oldDisplay) {
				dispatchEvent(new OneDisplayContainerEvent(OneDisplayContainerEvent.ADDED_CHILD));
			}
			return super.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			throw new IllegalOperationError("OneDisplayContainer don't support addChildAt");
			return null;
		}

		public function dispose():void {
			_currentChild = null;
		}
		
		public function get currentChild():DisplayObject {
			return _currentChild;
		}
	}
}
