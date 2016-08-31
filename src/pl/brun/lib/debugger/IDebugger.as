package pl.brun.lib.debugger {
	/**
	 * @author Marek Brun
	 */
	public interface IDebugger {

		function getLogging(obj:Object):Object;

		function showWindow(obj:Object):void;
		
		function get mainLogger():Object;
		
		function get logv():Object;
		
		function get links():Object;

		function sppedTestStart(id:String):void;

		function sppedTestStop(id:String):void;
	}
}
