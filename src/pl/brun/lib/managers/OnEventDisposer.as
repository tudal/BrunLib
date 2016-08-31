package pl.brun.lib.managers {
	import pl.brun.lib.Base;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.events.Event;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class OnEventDisposer extends Base {

		private static var instance:OnEventDisposer;

		public function OnEventDisposer() {
		}

		private function _addObjectToDispose(eventType:String, obj:IDisposable):void {
			obj.addEventListener(eventType, onDisposable_DisposeEvent, false, 0, false);
		}

		public static function addObjectToDispose(eventType:String, obj:IDisposable):void {
			getInstance()._addObjectToDispose(eventType, obj);
		}

		private static function getInstance():OnEventDisposer {
			if(instance) {
				return instance;
			}
			instance = new OnEventDisposer();
			return instance;
		}
		
		private function disposeObj(toDispose:IDisposable):void {
			toDispose.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onDisposable_DisposeEvent(event:Event):void {
			IDisposable(event.target).removeEventListener(event.type, onDisposable_DisposeEvent);
			FrameDelayCall.addCall(disposeObj, 1, [IDisposable(event.target)]);
		}
	}
}
