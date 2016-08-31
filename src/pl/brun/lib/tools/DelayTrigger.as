package pl.brun.lib.tools {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import pl.brun.lib.commands.ICommand;
	import pl.brun.lib.Base;

	/**
	 * 08-08-2012
	 * @author Marek Brun
	 */
	public class DelayTrigger extends Base implements ICommand {

		private var timer:Timer;
		private var cmd:ICommand;

		public function DelayTrigger(delay:uint, cmd:ICommand) {
			this.cmd = cmd
			timer = new Timer(delay, 1)
			addEventSubscription(timer, TimerEvent.TIMER_COMPLETE, onTimer_Complete)
		}

		public function execute():void {
			timer.reset()
			timer.start()
		}

		private function onTimer_Complete(event:TimerEvent):void {
			cmd.execute()
		}
	}
}
