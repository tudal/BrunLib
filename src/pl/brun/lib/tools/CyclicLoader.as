package pl.brun.lib.tools {
	import pl.brun.lib.commands.ICommand;

	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/**
	 * 07-02-2014
	 * @author Marek Brun
	 */
	public class CyclicLoader extends URLLoaderPlus {

		private var delay:uint;
		private var timer:Timer;

		public function CyclicLoader(delay:uint, request:URLRequest, dbgName:String, ioErrCmd:ICommand = null, timeoutCmd:ICommand = null, secErrCmd:ICommand = null) {
			super(dbgName, ioErrCmd, timeoutCmd, secErrCmd)
			this.request = request
			this.delay = delay
			startLoad()
			timer = new Timer(delay)
			timer.addEventListener(TimerEvent.TIMER, onTimer_Timer)
			timer.start()
		}

		private function onTimer_Timer(event:TimerEvent):void {
			if(!isLoading){
				startLoad()
			}
		}
		
		override public function dispose():void {
			timer.stop()
			super.dispose()
		}
	}
}