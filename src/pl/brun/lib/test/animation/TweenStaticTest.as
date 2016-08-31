package pl.brun.lib.test.animation {
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.animation.Tween;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.EasingUtil;
	import pl.brun.lib.test.TestBase;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class TweenStaticTest extends TestBase {

		private var mc:TweenStaticTestMC;

		public function TweenStaticTest() {
			mc = new TweenStaticTestMC();
			addChild(mc);
			
			var easingClasses:Array /*of Class*/= EasingUtil.getEasingClasses();
			var i:uint;
			var easingClass:Class;
			for(i = 0;i < easingClasses.length;i++) {
				easingClass = easingClasses[i];
				mc.comboEasings.addItem({data:easingClass, label:easingClass});
			}
			
			mc.comboEasings.selectedIndex = 0;
			
			MCButton.forInstance(mc.a).addEventListener(MouseEvent.CLICK, onA_Click);
			MCButton.forInstance(mc.b).addEventListener(MouseEvent.CLICK, onB_Click);
			MCButton.forInstance(mc.c).addEventListener(MouseEvent.CLICK, onC_Click);
			MCButton.forInstance(mc.d).addEventListener(MouseEvent.CLICK, onD_Click);
		}
		
		private function tweenBallToClip(tragetClip:MovieClip):void {
			var objectsAndProperties:Array/*of Array*/ = [[mc.ball, 'x', tragetClip.x], [mc.ball, 'y', tragetClip.y]];
			var time:uint=2000;
			var easing:Easing = new mc.comboEasings.selectedItem.data();
			var finishHandler:Function = onTweenFinish;
			Tween.tweenTo(objectsAndProperties, time, easing, onTweenFinish);
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onA_Click(event:MouseEvent):void {
			tweenBallToClip(mc.a);
		}

		private function onB_Click(event:MouseEvent):void {
			tweenBallToClip(mc.b);
		}

		private function onC_Click(event:MouseEvent):void {
			tweenBallToClip(mc.c);
		}

		private function onD_Click(event:MouseEvent):void {
			tweenBallToClip(mc.d);
		}

		private function onTweenFinish(event:ActionEvent):void {
			dbg.log('onTweenFinish()');
		}
	}
}