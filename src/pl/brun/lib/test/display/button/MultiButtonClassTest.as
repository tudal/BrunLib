package pl.brun.lib.test.display.button {
	import pl.brun.lib.display.button.ButtonEvent;
	import pl.brun.lib.display.button.MultiButton;
	import pl.brun.lib.display.button.SpriteButton;
	import pl.brun.lib.display.button.views.ButtonViewFactoryByLabel;
	import pl.brun.lib.test.TestBase;

	/**
	 * @author Marek Brun
	 */
	public class MultiButtonClassTest extends TestBase {
		private var mc:MultiButtonClassTestMC;
		private var multiButton:MultiButton;

		public function MultiButtonClassTest(isDebugger:Boolean = true) {
			super(isDebugger);
			
			mc = new MultiButtonClassTestMC();
			addChild(mc);
			
			multiButton = new MultiButton();
			multiButton.registerButton(SpriteButton.forInstance(mc.btn0));
			multiButton.addEventListener(ButtonEvent.OVER, onMultiButton_Over);
			
			multiButton.addViews(ButtonViewFactoryByLabel.createViewsByLabels(mc.btn0));
		}
		
		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onMultiButton_Out(event:ButtonEvent):void {
			dbg.log('onMultiButton_Out('+dbg.link(arguments[0], true)+')');
		}

		private function onMultiButton_Over(event:ButtonEvent):void {
			dbg.log('onMultiButton_Over('+dbg.link(arguments[0], true)+')');
		}
	}
}