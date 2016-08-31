package pl.brun.lib.util.func {
	import pl.brun.lib.tools.FrameDelayCall;
	/**
	 * 2011-02-20  08:58:08
	 * @author Marek Brun
	 */
	public function delayCall(func:Function, afterFrames:uint = 1, args:Array = null):void {
		FrameDelayCall.addCall(func, afterFrames, args)
	}
}
