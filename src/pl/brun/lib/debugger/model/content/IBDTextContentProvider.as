package pl.brun.lib.debugger.model.content {

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * 
	 * Events:
	 *  - Event.CHANGE
	 *  
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public interface IBDTextContentProvider extends IBDContentProvider {

		function getText():String;
	}
}
