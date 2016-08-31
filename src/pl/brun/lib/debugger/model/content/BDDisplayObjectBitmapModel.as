package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.display.BitmapProviderEvent;
	import pl.brun.lib.models.IBitmapProvider;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.util.BitmapUtils;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	/**
	 * created: 2009-12-25
	 * @author Marek Brun
	 */
	public class BDDisplayObjectBitmapModel extends Base implements IBDRefreshable, IBDContentProvider, IBitmapProvider {

		private var bd:BitmapData;		private var _isParentbitmapMode:Boolean;
		private var weaks:WeakReferences;
		private var displayRID:uint;

		public function BDDisplayObjectBitmapModel(display:DisplayObject, weaks:WeakReferences) {
			this.weaks = weaks;
			displayRID = weaks.getID(display);
			refresh();
		}

		public function refresh():void {
			var display:DisplayObject = weaks.getValue(displayRID);
			if(!display){
				return;
			}
			if(bd) {
				bd.dispose();
			}
			if(isParentbitmapMode){
				bd = BitmapUtils.getBitmapDataByDisplayParent(display);
			}else{
				bd = BitmapUtils.getBitmapDataByDisplay(display);
			}
			dispatchEvent(new BitmapProviderEvent(BitmapProviderEvent.NEW_BITMAP, bd));
		}

		public function getBitmap():BitmapData {
			return bd;
		}

		public function gotBitmap():Boolean {
			return Boolean(bd);
		}
		
		public function get isParentbitmapMode():Boolean {
			return _isParentbitmapMode;
		}
		
		public function set isParentbitmapMode(value:Boolean):void {
			if(_isParentbitmapMode == value){
				return;
			}			_isParentbitmapMode = value;
			refresh();
		}
	}
}
