package pl.brun.lib.models.video {

	/**
	 * @author Marek Brun
	 */
	public class VideoCuePoint {

		public var type:String;
		public var name:String;
		public var time:Number;
		public var parameters:Object;

		public function VideoCuePoint() {
		}

		static public function createByObject(info:Object):VideoCuePoint {
			var instance:VideoCuePoint = new VideoCuePoint();
			instance.type = info.type;
			return instance;
		}
	}
}