package pl.brun.lib.display {
	import pl.brun.lib.IDisposable;

	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 * @author Marek Brun
	 */
	public class ObjectByDisplayDisposer {

		private static const dictDisplayToObj:Dictionary = new Dictionary(true);

		public static function addToDispose(display:DisplayObject, obj:IDisposable):void {
			if(dictDisplayToObj[display]) {
				dictDisplayToObj[display].push(obj);
			} else {
				dictDisplayToObj[display] = [obj];
			}
		}

		public static function disposeDisplayObjects(display:DisplayObject):void {
			if(dictDisplayToObj[display]) {
				var objs:Array /*of IDisposable*/= dictDisplayToObj[display];
				var i:uint;
				var obj:IDisposable;
				for(i = 0;i < objs.length;i++) {
					obj = objs[i];
					obj.dispose();
				}
			}
		}
	}
}
