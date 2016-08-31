package pl.brun.lib.debugger {

	/**
	 * @author Marek Brun
	 */
	public class GlobalDbg {

		private static var ins:GlobalDbg;
		public var dbg:DebugServiceProxy;
		public var dbgName:String;

		public function GlobalDbg() {
			dbgName = "[global]"
			dbg = DebugServiceProxy.forInstance(this);
		}

		public static function get d():DebugServiceProxy {
			if (!ins) ins = new GlobalDbg();
			return ins.dbg
		}
		
	}
}
