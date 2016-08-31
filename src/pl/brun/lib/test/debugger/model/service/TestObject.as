package pl.brun.lib.test.debugger.model.service {
	import pl.brun.lib.Base;

	/**
	 * created: 2009-12-27
	 * @author Marek Brun
	 */
	dynamic public class TestObject extends Base {

		private var privateVariable:String = 'some private value';
		public var publicVariable:String = 'some public value';
		public var someLongHTML:String = '<FONT COLOR="#111222">s</FONT><FONT COLOR="#000FFF">o</FONT><FONT COLOR="#111222">m</FONT><FONT COLOR="#000FFF">e</FONT>';

		public function TestObject() {
			privateVariable;
			this.firstName = "Franek";
			this.age = 52;
			this.city = "Ladek Zdroj";
			this.isBald = true;
			this.dog = {bark:true};
			this.arr = ['zero', 'one', 2, {}, this];
			this.xml = <x><foo/><shmoo><bar><some></some></bar></shmoo></x>;
		}

		public function somePublicMethodNoArgs():String {
			return 'return value from calling somePublicMethodNoArgs()';
		}
	}
}
