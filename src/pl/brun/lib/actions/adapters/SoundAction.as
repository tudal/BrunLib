package pl.brun.lib.actions.adapters {
	import pl.brun.lib.actions.Action;

	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	 * @author Marek Brun
	 */
	public class SoundAction extends Action {

		private var sound:Sound;
		private var channel:SoundChannel;

		public function SoundAction(sound:Sound) {
			this.sound = sound;
		}

		override protected function doRunning():void {
			channel = sound.play();
		}

		override protected function doIdle():void {
			channel.stop();
			channel = null;
		}
	}
}
