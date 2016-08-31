package pl.brun.lib.models {
	import flash.events.IEventDispatcher;

	[Event(name="select", type="pl.brun.lib.events.SelectIndexEvent")]

	/**
	 * created:2010-09-29  13:45:42
	 * @author Marek Brun
	 */
	public interface ISelectableModel extends IEventDispatcher {
		
		function selectByIndex(index:uint):void;
		
		function getSelectByIndex():uint;
		
	}
}
