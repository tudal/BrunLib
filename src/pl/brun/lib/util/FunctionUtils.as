package pl.brun.lib.util {
	import flash.errors.IllegalOperationError;

	/**
	 * created:2010-09-22  11:31:28
	 * @author Marek Brun
	 */
	public class FunctionUtils {
		
		public static function call(func:Function, args:Array/*of * */=null):* {
			if(args && args.length > 4) {
				throw new IllegalOperationError("Max number supported of arguments are 4 (you passed " + args.length + ")");
			}
			if(args) {
				return func.apply(undefined, args);
				switch(args.length) {
					case 0:
						return func();
						break;
					case 1:
						return func(args[0]);
						break;
					case 2:
						return func(args[0], args[1]);
						break;
					case 3:
						return func(args[0], args[1], args[2]);
						break;
					case 4:
						return func(args[0], args[1], args[2], args[3]);
						break;
				}
			}
			return func();
		}
	}
}
