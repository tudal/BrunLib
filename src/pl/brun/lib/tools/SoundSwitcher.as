package pl.brun.lib.tools {
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
	public class SoundSwitcher extends Base implements ICookieDataProvider {
		public var volumeBeforeMute:Number;
		private var _isMute:Boolean;
		private var cookie:EasyCookie;

		public function SoundSwitcher() {
			_isMute = !SoundMixer.soundTransform.volume
			cookie = new EasyCookie(this, "soundSwitcher", false)
		}

		public function mute():void {
			if (_isMute) {
				return
			}
			_isMute = true
			volumeBeforeMute = SoundMixer.soundTransform.volume
			SoundMixer.soundTransform = new SoundTransform(0)
			if (cookie) cookie.flush();
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function unmute():void {
			if (!_isMute) {
				return
			}
			_isMute = false
			SoundMixer.soundTransform = new SoundTransform(volumeBeforeMute || 1)
			cookie.flush()
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function switchMute():void {
			if (_isMute) {
				unmute()
			} else {
				mute()
			}
		}

		public function get isMute():Boolean {
			return _isMute;
		}

		public function getSharedObjectInitData():Object {
			return {isMute:false};
		}

		public function applySharedObjectData(data:Object):void {
			data.isMute ? mute() : unmute()
		}

		public function getSharedObjectData():Object {
			return {isMute:isMute};
		}
	}
}
