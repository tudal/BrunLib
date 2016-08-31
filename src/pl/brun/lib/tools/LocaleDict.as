package pl.brun.lib.tools {
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * @author Marek Brun
	 */
	public class LocaleDict extends EventDispatcher {
		private static var instance:LocaleDict;
		private var dict:Dictionary = new Dictionary();
		public var gotData:Boolean;
		private var loader:URLLoader;

		public function LocaleDict() {
		}

		public static function addWord(word:String, translation:String):void {
			getInstance().dict[word] = translation
		}

		public static function addToWord(word:String, translation:String):void {
			getInstance().dict[word] += translation
		}

		public static function translate(key:String, option:String = null):String {
			if (getInstance().dict[key]) {
				var tra:String = getInstance().dict[key];
				if (option == 'UP') {
					tra = tra.substr(0, 1).toLocaleUpperCase() + tra.substr(1).toLocaleLowerCase()
				}else if (option == 'LO') {
					tra = tra.substr(0, 1).toLocaleLowerCase() + tra.substr(1).toLocaleLowerCase()
				}
				return tra;
			}
			return '[' + key + ']'
		}

		public static function getInstance():LocaleDict {
			if (!instance) instance = new LocaleDict();
			return instance
		}

		public static function parseLocaleTxt(localeTxt:String, clearOld:Boolean = false):void {
			if (clearOld) {
				getInstance().dict = new Dictionary()
			}
			localeTxt = localeTxt.split('\r').join('')
			var localeArr:Array = localeTxt.split('\n')
			var lastWord:String
			for each (var locale:String in localeArr) {
				if (!locale.length) continue;
				if (locale.indexOf("=") > -1) {
					lastWord = locale.split("=")[0]
					LocaleDict.addWord(lastWord, locale.split("=")[1].split('^').join('='))
				} else {
					LocaleDict.addToWord(lastWord, '\n' + locale.split('^').join('='))
				}
			}
			instance.gotData = true
			instance.dispatchEvent(new Event(Event.CHANGE))
		}

		public function load(url:String):void {
			loader = new URLLoader()
			loader.addEventListener(Event.COMPLETE, onLoader_Complete)
			loader.load(new URLRequest(url))
		}

		private function onLoader_Complete(event:Event):void {
			parseLocaleTxt(loader.data)
		}
	}
}
/*

example locale file:

dog=pies
sentence=Ala ma kota
Kot ma ale
cat=kot


 */