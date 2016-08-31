package pl.brun.lib.debugger {

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDLinkVO {
		public function BDLinkVO() {
			
		}


		public static const TYPE_EXE:String = 'exe';		public static const TYPE_OBJECT:String = 'object';		public static const TYPE_LONG_STRING:String = 'longString';
		public var type:String;		public var value:*;
	}
}
