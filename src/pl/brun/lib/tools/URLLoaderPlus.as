package pl.brun.lib.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.commands.ICommand;
	import pl.brun.lib.debugger.GlobalDbg;
	import pl.brun.lib.util.ByteArrayUtils;
	import pl.brun.lib.util.TimeInMs;
	import pl.brun.lib.util.func.timeAgo;

	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setInterval;

	/** fail but will still try to load */
	[Event(name="fail", type="pl.brun.lib.tools.URLLoaderPlusEvent")]
	/** completed with success */
	[Event(name="complete", type="pl.brun.lib.tools.URLLoaderPlusEvent")]
	/** completed with fail */
	[Event(name="cantLoad", type="pl.brun.lib.tools.URLLoaderPlusEvent")]
	/** completed with error or success */
	[Event(name="finish", type="pl.brun.lib.tools.URLLoaderPlusEvent")]
	/**
	 * @author Marek Brun
	 */
	public class URLLoaderPlus extends Base {
		public static const FAIL_IO:uint = 1;
		public static const FAIL_TIMEOUT:uint = 2;
		public static const FAIL_SECURITY:uint = 3;
		public static const FAIL_APPLY_INTERNAL:uint = 4;
		public static const FAIL_APPLY_EXTERNAL:uint = 5;
		public var timeout:uint = 30 * 1000;
		/**
		 * false - app will try to load data forever 
		 * true - app will stop trying to load data after maxRetryAttempts
		 */
		public var isRetryLimit:Boolean = false;
		public var maxRetryAttempts:uint = 3;
		public var afterRetryTime:uint = 10 * 1000;
		public var maxAfterRetryTime:uint = 2 * TimeInMs.MINUTE;
		public var afterRetryTimeMultipler:Number = 1.5;
		public var dataFormat:String = URLLoaderDataFormat.TEXT;
		public var request:URLRequest;
		private var state:State;
		public var secErrCmd:ICommand;
		public var timeoutCmd:ICommand;
		public var ioErrCmd:ICommand;
		public var loadedData:*;
		public var lastLoadAttempt:uint;
		public static const dictDbgNameToInfoObj:Dictionary = new Dictionary();
		public static var totalLoaded:Number = 0;
		public static var totalLoadedUpdateStarted:Boolean;
		public static var isDBGMode:Boolean;
		public var failType:uint;
		public var isSuccess:Boolean;
		public var priority:uint;
		public var userAgent:String = 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.118 Safari/537.36';

		public function URLLoaderPlus(dbgName:String, ioErrCmd:ICommand = null, timeoutCmd:ICommand = null, secErrCmd:ICommand = null) {
			this.dbgName = dbgName
			dbg.logvID = 'loader'
			dbg.logvID2 = dbgName
			this.ioErrCmd = ioErrCmd
			this.timeoutCmd = timeoutCmd
			this.secErrCmd = secErrCmd

			if (!URLLoaderPlus.dictDbgNameToInfoObj[dbgName]) {
				URLLoaderPlus.dictDbgNameToInfoObj[dbgName] = {bytes:0, ok:0, fail:0, start:0}
			}

			if (!totalLoadedUpdateStarted) {
				totalLoadedUpdateStarted = true
				setInterval(updateTotalStats, TimeInMs.MINUTE)
			}

			setState(new IdleState())
		}

		public function finish():void {
			dispatchEvent(new URLLoaderPlusEvent(URLLoaderPlusEvent.FINISH))
		}

		public function cantLoad():void {
			dispatchEvent(new URLLoaderPlusEvent(URLLoaderPlusEvent.CANT_LOAD))
		}

		/*abstract*/
		public function applyData():Boolean {
			return true
		}

		public function complete():void {
			if (isDBGMode) dbg.logv('data', dbg.link(loadedData, false));
			isSuccess = true
			dispatchEvent(new URLLoaderPlusEvent(URLLoaderPlusEvent.COMPLETE))
		}

		public function setup(request:URLRequest):void {
			this.request = request
		}

		public function cancel():void {
			if (isLoading) {
				state.cancel()
			}
		}

		public function startLoad():void {
			URLLoaderPlus.dictDbgNameToInfoObj[dbgName].start++
			if (isDBGMode) dbg.logv('start', URLLoaderPlus.dictDbgNameToInfoObj[dbgName].start);
			if (isDBGMode) dbg.logv('reload time', timeAgo(getTimer() / URLLoaderPlus.dictDbgNameToInfoObj[dbgName].start));
			state.startLoad(false)
		}

		public function reloadAfterDataApplyError():void {
			state.startLoad(true)
		}

		public function setState(state:State):void {
			if (this.state) {
				this.state.dispose()
			}
			this.state = state
			// dbg.log('state:' + state)
			if (isDBGMode) dbg.logv('state', state);
			state.init(this)
			state.start()
		}

		public static function updateTotalStats():void {
			GlobalDbg.d.logv('  total loaded bytes', ByteArrayUtils.readablizeBytes(URLLoaderPlus.totalLoaded))
			GlobalDbg.d.logv('  total loaded bytes daily', ByteArrayUtils.readablizeBytes(URLLoaderPlus.totalLoaded * (TimeInMs.DAY / getTimer())) + '/day')
		}

		public function fail(failType:uint):void {
			var failText:String = '?'
			switch(failType) {
				case FAIL_IO:
					failText = 'IO ERROR'
					break;
				case FAIL_TIMEOUT:
					failText = 'TIMEOUT'
					break;
				case FAIL_SECURITY:
					failText = 'SECURITY'
					break;
					failText = 'APPLY_INTERNAL'
				case FAIL_APPLY_INTERNAL:
					break;
					failText = 'APPLY_EXTERNAL'
				case FAIL_APPLY_EXTERNAL:
					break;
			}
			// dbg.log('<b>fail to load, reason:' + failText + '</b> url:' + request.url) changed!
			this.failType = failType;
			dispatchEvent(new URLLoaderPlusEvent(URLLoaderPlusEvent.FAIL))
		}

		public function get isLoading():Boolean {
			return !(state is IdleState)
		}

		override public function dispose():void {
			if (state) {
				state.dispose()
				state = null
			}
			super.dispose()
		}

		public function getStatus():String {
			return String(state)
		}

		public function getURL():String {
			if (request) {
				return request.url;
			}
			return 'none'
		}
	}
}
import pl.brun.lib.Base;
import pl.brun.lib.tools.URLLoaderPlus;
import pl.brun.lib.util.ByteArrayUtils;
import pl.brun.lib.util.CapabilitiesUtils;
import pl.brun.lib.util.TimeInMs;
import pl.brun.lib.util.func.timeAgo;

import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.utils.Timer;
import flash.utils.getTimer;

class State extends Base {
	protected var main:URLLoaderPlus;
	private var timer:Timer;

	public function State() {
	}

	public function init(main:URLLoaderPlus):void {
		this.main = main
	}

	public function start():void {
	}

	public function startTimer(delay:Number):void {
		if (!timer) {
			timer = new Timer(delay, 1)
			addEventSubscription(timer, TimerEvent.TIMER_COMPLETE, onTimer)
		}
		timer.reset()
		timer.start()
	}

	private function onTimer(event:TimerEvent):void {
		doOnTimer()
	}

	protected function doOnTimer():void {
	}

	override public function dispose():void {
		if (timer) timer.stop();
		super.dispose()
	}

	public function startLoad(afterApplyError:Boolean):void {
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('próba rozpoczęcia wcztywania   ...podczas wczytywania', main.request ? main.request.url : null);
		if (URLLoaderPlus.isDBGMode) main.dbg.log('<b>próba rozpoczęcia wcztywania   ...podczas wczytywania</b>');
	}

	public function cancel():void {
	}
}
class IdleState extends State {
	public function IdleState() {
	}

	override public function startLoad(afterApplyError:Boolean):void {
		if (main.request) {
			if (afterApplyError) {
				main.setState(new AfterFailState(main.lastLoadAttempt + 1))
			} else {
				main.setState(new LoadingState(0))
			}
		} else {
			if (URLLoaderPlus.isDBGMode) main.dbg.logv('próba startu wczytywania bez wskazania urla');
			if (URLLoaderPlus.isDBGMode) main.dbg.log('<b>próba startu wczytywania bez wskazania urla</b>');
		}
	}
}
class LoadingState extends State {
	private var loadAttempt:uint;
	private var loader:URLLoader;
	private var statusEvent:HTTPStatusEvent;

	public function LoadingState(loadAttempt:uint) {
		this.loadAttempt = loadAttempt
	}

	override public function start():void {
		main.failType = 0
		main.isSuccess = false
		startTimer(main.timeout)
		loader = new URLLoader()
		loader.addEventListener(IOErrorEvent.IO_ERROR, onIO)
		addEventSubscription(loader, IOErrorEvent.IO_ERROR, onLoader_IOError)
		addEventSubscription(loader, SecurityErrorEvent.SECURITY_ERROR, onLoader_SecurityError)
		addEventSubscription(loader, Event.COMPLETE, onLoader_Complete)
		// addEventSubscription(loader, HTTPStatusEvent.HTTP_RESPONSE_STATUS, onLoader_Status)
		addEventSubscription(loader, HTTPStatusEvent.HTTP_STATUS, onLoader_Status)
		loader.dataFormat = main.dataFormat
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('url', main.request.url);
		if (CapabilitiesUtils.isAir() && main.request.userAgent && main.userAgent) {
			main.request.userAgent = main.userAgent
		}
		loader.load(main.request)
	}

	private function onLoader_Status(event:HTTPStatusEvent):void {
		statusEvent = event
	}

	private function onIO(event:IOErrorEvent):void {
		main = main
	}

	override protected function doOnTimer():void {
		if (loader.bytesTotal > 1000 && loader.bytesLoaded / loader.bytesTotal > 0.1) {
			startTimer(main.timeout)
			return;
		}

		try {
			if (main.timeoutCmd) {
				main.timeoutCmd.execute()
			}
		} catch(e:Error) {
		}

		fail(URLLoaderPlus.FAIL_TIMEOUT)
	}

	private function onLoader_Complete(event:Event):void {
		main.loadedData = loader.data

		if (main.applyData()) {
			URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].ok++
			if (URLLoaderPlus.isDBGMode) main.dbg.logv('success', URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].ok);
			main.setState(new IdleState())
			main.lastLoadAttempt = loadAttempt
			main.complete()
			main.finish()
		} else {
			fail(URLLoaderPlus.FAIL_APPLY_INTERNAL)
		}
	}

	private function onLoader_SecurityError(event:SecurityErrorEvent):void {
		main.dbg.log("onLoader_SecurityError(" + dbg.linkArr(arguments, true)+")")
		try {
			if (main.secErrCmd) {
				main.secErrCmd.execute()
			}
		} catch(e:Error) {
		}
		fail(URLLoaderPlus.FAIL_SECURITY)
	}

	private function onLoader_IOError(event:IOErrorEvent):void {
		dbg.logv('IO Error', main.request.url)
		try {
			if (main.ioErrCmd) {
				main.ioErrCmd.execute()
			}
		} catch(e:Error) {
		}
		fail(URLLoaderPlus.FAIL_IO)
	}

	private function fail(failType:uint):void {
		main.fail(failType)
		if (main.isRetryLimit && loadAttempt + 1 > main.maxRetryAttempts) {
			main.setState(new IdleState())
			main.cantLoad()
			main.finish()
		} else {
			main.setState(new AfterFailState(loadAttempt))
		}
	}

	override public function cancel():void {
		loader.close()
		main.setState(new IdleState())
	}

	override public function dispose():void {
		URLLoaderPlus.totalLoaded += loader.bytesLoaded
		URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].bytes += loader.bytesLoaded
		var bytes:uint = URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].bytes
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('loaded bytes', ByteArrayUtils.readablizeBytes(bytes))
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('loaded bytes daily', ByteArrayUtils.readablizeBytes(bytes * (TimeInMs.DAY / getTimer())) + '/day')
		URLLoaderPlus.updateTotalStats()
		try {
			// **loader.close()
			// **loader.data = null
		} catch(e:Error) {
		}
		super.dispose()
	}
}
class AfterFailState extends State {
	private var loadAttempt:uint;

	public function AfterFailState(loadAttempt:uint) {
		this.loadAttempt = loadAttempt
	}

	override public function start():void {
		URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].fail++
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('fails', URLLoaderPlus.dictDbgNameToInfoObj[main.dbgName].fail)

		var time:Number = main.afterRetryTime * Math.pow(main.afterRetryTimeMultipler, loadAttempt + 1)
		time = Math.min(main.maxAfterRetryTime, time)
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('retry time', timeAgo(time))
		if (URLLoaderPlus.isDBGMode) main.dbg.logv('load attempt', loadAttempt)
		startTimer(time)
	}

	override protected function doOnTimer():void {
		main.setState(new LoadingState(loadAttempt + 1))
	}

	override public function cancel():void {
		main.setState(new IdleState())
	}
}
