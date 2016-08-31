package pl.brun.lib.models {
	import pl.brun.lib.IDisposable;

	import flash.events.IEventDispatcher;

	[Event(name="lengthChanged", type="pl.brun.lib.events.EventPlus")]

	/**
	 * @author Marek Brun
	 */
	public interface IArrangeable extends IEventDispatcher, IDisposable {

		function get position():Number
		function set position(value:Number):void

		function get shortPosition():Number

		function set shortPosition(value:Number):void
		function get length():Number
		
		function get shortness():Number
	}
}
