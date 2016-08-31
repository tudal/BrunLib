package pl.brun.lib {
	import flash.events.IEventDispatcher;

	[Event(name="beforeDisposed", type="pl.brun.lib.events.EventPlus")]

	/**
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public interface IDisposable extends IEventDispatcher {

		/**
		 * returns disposeChild back
		 */
		function addDisposeChild(disposeChild:IDisposable):*;

		function addDisposeChildren(disposeChilds:Array/*of IDisposable*/):void;

		function dispose():void;

		function get isDisposed():Boolean;
	}
}
