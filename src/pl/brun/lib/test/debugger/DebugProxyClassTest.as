package pl.brun.lib.test.debugger {
	import pl.brun.lib.debugger.DebugServiceProxy;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.test.debugger.model.service.TestObject;
	import pl.brun.lib.util.KeyCode;

	import flash.display.Sprite;
	import flash.filters.GlowFilter;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class DebugProxyClassTest extends TestBase {

		private var testObj:TestObject;
		private var debuggerHolder:Sprite;
		private var servidecMC:BFLA_animtoDebug2MC;
		private var dbg2:DebugServiceProxy;
		
		override protected function init():void {
			super.init()
			
			debuggerHolder = new Sprite();
			addChild(debuggerHolder);
			
			testObj = new TestObject();
			
			dbg2 = DebugServiceProxy.forInstance(testObj);
			
			dbg2.log('Hello world');
			dbg2.log('dc:' + dbg2.link(this));
			
			dbg2.contextLog('x', '"x" 1 context log ');			dbg2.registerInContex('x');
			dbg2.contextLog('x', '"x" 2 context log ');

			var vector:Vector.<String>=new <String>['ala','ma','kota']
			dbg2.log("vector:"+dbg2.link(vector, true))
			
			
			servidecMC = new BFLA_animtoDebug2MC();
			servidecMC.filters = [new GlowFilter()];
			servidecMC.scaleY = 0.5;
			servidecMC.x = 100;
			servidecMC.y = 200;
			addChild(servidecMC);
			
			addTestKey(KeyCode.D, disposeTest, null, 'disposeTest();');
		}

		private function disposeTest():void {
			testObj.dispose();
		}
	}
}
