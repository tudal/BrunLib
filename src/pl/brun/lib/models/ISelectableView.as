package pl.brun.lib.models {
	import flash.events.IEventDispatcher;

	[Event(name="selectRequest", type="pl.brun.lib.events.SelectEvent")]

	/**
	 * created:2010-09-29  13:40:57
	 * @author Marek Brun
	 */
	public interface ISelectableView extends IEventDispatcher {

		function select():void;

		function deselect():void;
	}
}
