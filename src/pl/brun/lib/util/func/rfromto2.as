package pl.brun.lib.util.func {
	/**
	 * @author Marek Brun
	 */
	public function rfromto2(from:Number, to:Number):Number {
		var len:Number = to - from
		return from + Math.random()*(len+1)
	}
}
