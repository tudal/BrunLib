package pl.brun.lib.util.func {
	import pl.brun.lib.util.StringUtils;
	import pl.brun.lib.util.TimeInMs;

	/**
	 * @author Marek Brun
	 */
	public function timeAgo(time:Number, ago:String = "ago"):String {
		var arr:Array = [
			["s", 1000],
			["m", TimeInMs.MINUTE],
			["h", TimeInMs.HOUR],
			["d", TimeInMs.DAY],
			["w", TimeInMs.WEEK],
			["mon", TimeInMs.MONTH],
			["y", TimeInMs.YEAR],
		]
		var t:Array
		
		while (arr.length) {
			t = arr.pop()
			if (time > t[1]) {
				var mainTime:uint = Math.floor(time / t[1])
				if (arr.length > 0) {
					var main:String = String(mainTime + t[0])
					if(t[0].length>1 && mainTime>1) main+='s'
					
					var prevT:Array = arr.pop()
					var tSub:uint = Math.floor(time % t[1]) / prevT[1]
					var sub:String = String(tSub + prevT[0])
					//if(prevT[0].length>1 && tSub>1 && t[0]!='mon' && t[0]!='y') sub+='s'
					return main + ' ' + sub
				}
				return StringUtils.frontZero(2, mainTime) + t[0]
			}
		}
		return '00s';
	}
}
