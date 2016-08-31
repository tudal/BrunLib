package pl.brun.lib.util.func {
	/**
	 * @author Marek
	 */
	public function range(from:Number, to:uint, value:Number):Number {
		return Math.max(Math.min(to, value));
	}
}
