package pl.brun.lib.tools {
	import flash.utils.setTimeout;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.Base;

	/**
	 * 01-10-2013
	 * @author Marek Brun
	 */
	public class Timeout extends Base {

		private static var instance:Timeout;

		public function Timeout() {
		}

		public static function ins():Timeout {
			if (!instance) {
				instance = new Timeout()
			}
			return instance
		}

		public static function sett(obj:IDisposable, delay:Number, func:Function, args:Array=null):void {
			setTimeout(ins().execute, delay, obj, func, args)
		}

		private function execute(obj:IDisposable, func:Function, args:Array=null):void {
			if(!obj.isDisposed){
				if(args && args.length){
					func.apply(obj, args)
				}else{
					func()
				}
			}
		}
	}
}
