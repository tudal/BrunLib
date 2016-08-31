package pl.brun.lib.models {
	import flash.events.IEventDispatcher;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * created:2010-10-01  13:21:18
	 * @author Marek Brun
	 */
	public interface IValidatable extends IEventDispatcher {

		function isValid():Boolean;
	}
}
