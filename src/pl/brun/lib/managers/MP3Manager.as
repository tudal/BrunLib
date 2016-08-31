/*
 * Copyright 2009 Marek Brun
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *    
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package pl.brun.lib.managers {
	import pl.brun.lib.Base;

	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * Just play mp3 from specifed URL in streaming.
	 * Sound objects are remembered (by URL) and reused.
	 * 
	 * Handy for short, no-infinite-loop sounds.
	 * 
	 * created:2009-11-14 
	 * @author Marek Brun
	 */
	public class MP3Manager extends Base {

		static private var instance:MP3Manager;
		private var dictURLRequest_Sound:Dictionary = new Dictionary();
		private static var volumeforAll:Number;

		public function MP3Manager(access:Private) {
		}

		private function _play(stream:URLRequest, loops:uint = 0):SoundChannel {
			var sound:Sound;
			if(!dictURLRequest_Sound[stream.url]) {
				sound = new Sound();
				sound.load(stream);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onSound_IOError);
				dictURLRequest_Sound[stream.url] = sound;
			}
			sound = dictURLRequest_Sound[stream.url];
			var channel:SoundChannel = sound.play(0, loops);
			if(!isNaN(volumeforAll)) {
				var st:SoundTransform = channel.soundTransform;
				st.volume = volumeforAll;
				channel.soundTransform = st;
			}
			return channel;
		}

		public static function play(url:URLRequest, loops:uint = 0):SoundChannel {
			return getInstance()._play(url, loops);
		}

		public static function setVolumeforAll(volume:Number):void {
			volumeforAll = volume;
		}

		static public function getInstance():MP3Manager {
			if(instance) { 
				return instance; 
			} else { 
				instance = new MP3Manager(null); 
				return instance;
			}
		}

		//--------------------------------------------------------------------------
		//		handlers
		//--------------------------------------------------------------------------
		private function onSound_IOError(event:IOErrorEvent):void {
			dbg.log('onSound_IOError(' + dbg.link(arguments[0], true) + ')');
		}
	}
}

internal class Private {
}