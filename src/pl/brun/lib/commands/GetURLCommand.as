package pl.brun.lib.commands {
	import pl.brun.lib.Base;

	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Marek Brun
	 */
	public class GetURLCommand extends Base implements ICommand {

		private var url:URLRequest;
		private var target:String;

		public function GetURLCommand(url:URLRequest, target:String="_blank") {
			this.target = target;
			this.url = url;
		}
		
		public function execute():void {
			navigateToURL(url, target);
		}
		
	}
}
