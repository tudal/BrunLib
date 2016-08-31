package pl.brun.lib.util.func {
	/**
	 * @author Marek Brun
	 */
	public function rfromto(from:int, to:int):int {
		var len:Number = to - from
		return from + Math.random()*(len+1)
	}
}
