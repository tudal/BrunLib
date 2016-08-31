package pl.brun.lib.managers {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.EasyCookie;
	import pl.brun.lib.models.ICookieDataProvider;

	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * @author Marek Brun
	 */
	public class SoundVolumeManager extends Base implements ICookieDataProvider {

		private static var instance:SoundVolumeManager;
		private var _volume:Number;
		private var cookie:EasyCookie;

		public function SoundVolumeManager(access:Private) {
			
			cookie = new EasyCookie(this, 'SoundVolumeManager');
			
		}

		public function get volume():Number {
			return _volume;
		}

		public function set volume(value:Number):void {
			if(_volume == value) {
				return;
			}
			setVolume(value);
			cookie.flush();
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function setVolume(value:Number):void {
			var soundTransform:SoundTransform = SoundMixer.soundTransform;
			soundTransform.volume = value;
			SoundMixer.soundTransform = soundTransform;
			_volume = value;
		}

		
		public static function getInstance():SoundVolumeManager {
			if(instance) { 
				return instance; 
			} else { 
				instance = new SoundVolumeManager(null); 
				return instance; 
			}
		}

		public function getSharedObjectInitData():Object {
			return {v:0.3};
		}

		public function applySharedObjectData(data:Object):void {
			setVolume(data.v);
		}

		public function getSharedObjectData():Object {
			return {v:volume};
		}
	}
}

internal class Private {
}