package pl.brun.lib.models {
	import pl.brun.lib.Base;
	import pl.brun.lib.tools.FrameDelayCall;

	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;

	/**
	 * EasyCookie offers simplified way to store data in shared objects.
	 * Just implement ICookieDataProvider
	 * 
	 * @author Marek Brun
	 */
	public class EasyCookie extends Base {
		private var obj:ICookieDataProvider;
		private var cookie:SharedObject;
		private var uniqueName:String;
		public var data:Object;
		private var flushTimeout:Timer;

		public function EasyCookie(obj:ICookieDataProvider, uniqueName:String, apply1FrameDelay:Boolean = true) {
			this.uniqueName = uniqueName;
			this.obj = obj;

			try {
				cookie = SharedObject.getLocal(uniqueName);
			} catch(e:Error) {
				dbg.log('cookie error:' + e)
			}
			if (cookie) {
				if (!cookie.data.isInit) {
					cookie.data.isInit = true;
					data = obj.getSharedObjectInitData();
					cookie.data.data = data
					if (!cookie.data.data) cookie.data.data = {}
					cookie.flush();
				}
				if (apply1FrameDelay) {
					FrameDelayCall.addCall(applySharedObjectData)
				} else {
					applySharedObjectData()
				}

				flushTimeout = new Timer(1000, 1)
				flushTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, onFlushTimeout_Complete)
			}
		}

		private function onFlushTimeout_Complete(event:TimerEvent):void {
			flush()
		}

		public function update():void {
			cookie = SharedObject.getLocal(uniqueName);
			applySharedObjectData()
		}

		private function applySharedObjectData():void {
			data = getSharedObjectData()
			obj.applySharedObjectData(data);
		}

		public function flush():void {
			if(!cookie) return;
			dbg.logv(' flush', uniqueName)
			cookie.data.data = obj.getSharedObjectData();
			cookie.flush();
		}

		public function flushWithTimeout():void {
			flushTimeout.reset()
			flushTimeout.start()
		}

		public function getSharedObjectData():* {
			return cookie.data.data
		}

		public function reset():void {
			cookie.data.data = obj.getSharedObjectInitData()
			cookie.flush()
			applySharedObjectData()
		}
	}
}

