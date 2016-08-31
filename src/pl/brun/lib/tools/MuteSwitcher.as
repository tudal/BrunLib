package pl.brun.lib.tools {
	import flash.events.Event;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;

	import pl.brun.lib.Base;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * @author Marek Brun
	 */
	public class MuteSwitcher extends Base {

		public var volumeBeforeMute:Number;
		private var _isMute:Boolean;

		public function MuteSwitcher() {
			_isMute = !SoundMixer.soundTransform.volume
		}

		public function mute():void {
			if(_isMute) {
				return
			}			_isMute = true
			volumeBeforeMute = SoundMixer.soundTransform.volume
			SoundMixer.soundTransform = new SoundTransform(0)
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function unmute():void {
			if(!_isMute) {
				return
			}
			_isMute = false
			SoundMixer.soundTransform = new SoundTransform(volumeBeforeMute || 1)
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function switchMute():void {
			if(_isMute) {
				unmute()
			} else {
				mute()
			}
		}

		public function get isMute():Boolean {
			return _isMute;
		}
	}
}
