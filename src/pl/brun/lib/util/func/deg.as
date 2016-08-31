package pl.brun.lib.util.func {
	/**
	 * @author Marek Brun
	 */
	public function deg(radians:Number):Number {
		var degs:Number = (radians * (180 / Math.PI)) % 360
		if (degs < 0) return degs + int((-degs) / 360 + 1) * 360
		return degs
	}
}
