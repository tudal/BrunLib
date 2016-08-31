package pl.brun.lib.util.func {
	import pl.brun.lib.tools.Timeout;
	import pl.brun.lib.IDisposable;
	/**
	 * 01-10-2013
	 * @author Marek Brun
	 */
	public function setTimeout2(obj:IDisposable, delay:Number, func:Function, args:Array=null):void {
		Timeout.sett(obj, delay, func, args)
	}
}
