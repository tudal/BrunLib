package pl.brun.lib.util.func {
	import pl.brun.lib.IDisposable;
	/**
	 * @author Marek
	 */
	public function disposeArr(arr:Array):void {
		while(arr.length){
			IDisposable(arr.pop()).dispose();
		}
	}
}
