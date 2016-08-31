package pl.brun.lib.commands {
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	/**
	 * created:2010-12-10  15:11:33
	 * @author Marek Brun
	 */
	public class EventAsSignal extends Signal {
		
		public function EventAsSignal(obj:IEventDispatcher, eventType:String) {
			addEventSubscription(obj, eventType, onObj_Event)
		}

		private function onObj_Event(event:Event):void {
			execute()
		}
	}
}
