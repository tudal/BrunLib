package pl.brun.lib.models.video {
	import flash.utils.Dictionary;

	/**
	 * At http://www.buraks.com/flvmdi/ you can find tool for editing flv metadata and description of the metadata properties.
	 * 
	 * @author Marek Brun
	 */
	public class VideoMetaData {

		public var duration:Number;
		public var lasttimestamp:Number;
		public var lastkeyframetimestamp:Number;
		public var width:Number;
		public var height:Number;
		public var videodatarate:Number;
		public var audiodatarate:Number;
		public var framerate:Number;
		public var creationdate:String;
		public var filesize:Number;
		public var videosize:Number;
		public var audiosize:Number;
		public var datasize:Number;
		public var metadatacreator:String;
		public var metadatadate:Date;
		public var xtradata:String;
		public var videocodecid:Number;
		public var audiocodecid:Number;
		public var audiodelay:Number;
		public var canSeekToEnd:Boolean;
		public var keyframes:Object; 		public var cuePoints:Array = [];
		private var dictTime_CuePoint:Dictionary = new Dictionary();

		public function addCuePoint(cuePoint:VideoCuePoint):void {
			cuePoints.push(cuePoint);
			dictTime_CuePoint[cuePoint.time] = cuePoint;
		}

		public function getCuePointByTime(time:Number):VideoCuePoint {
			return dictTime_CuePoint[time];
		}

		static public function createByObject(info:Object):VideoMetaData {
			var instance:VideoMetaData = new VideoMetaData();
			for(var key:String in info) {
				if(key == 'cuePoints') { 
					continue; 
				}
				try {
					instance[key] = info[key];
				}catch(e:*) {
				}
			}
			
			if(info.cuePoints && info.cuePoints.length) {
				var i:uint;
				var loop:Object;
				for(i = 0;i < info.cuePoints.length;i++) {
					loop = info.cuePoints[i];
					instance.addCuePoint(VideoCuePoint.createByObject(loop));
				}
			}
			
			return instance;
		}
	}
}
