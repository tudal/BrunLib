package pl.brun.lib.test.animation {
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.implementations.EnterFrameAction;
	import pl.brun.lib.animation.Tween;
	import pl.brun.lib.display.button.MCButton;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class TweenDynamicTest extends TestBase {

		private var mc:TweenDynamicTestMC;
		private var foo:EnterFrameAction;
		private var isInertial:Boolean;
		private var _inertialAcceleration:Number;
		private var _inertialFriction:Number;
		private var _stoppingSpeed:Number;
		private var sliderInertialFriction:PropertySlider;
		private var sliderInterialAcceleration:PropertySlider;
		private var sliderStoppingSpeed:PropertySlider;

		public function TweenDynamicTest() {
			mc = new TweenDynamicTestMC();
			addChild(mc);
			
			MCButton.forInstance(mc.a).addEventListener(MouseEvent.CLICK, onA_Click);
			MCButton.forInstance(mc.b).addEventListener(MouseEvent.CLICK, onB_Click);			MCButton.forInstance(mc.c).addEventListener(MouseEvent.CLICK, onC_Click);			MCButton.forInstance(mc.d).addEventListener(MouseEvent.CLICK, onD_Click);
			
			_inertialAcceleration = 0.5;			_inertialFriction = 0.4;			_stoppingSpeed = 0.5;
			
			foo = new EnterFrameAction();
			foo.start();
			
			sliderInertialFriction = new PropertySlider(mc.sliderInertialFriction, this, 'inertialFriction', 0, 1);			sliderInterialAcceleration = new PropertySlider(mc.sliderInterialAcceleration, this, 'inertialAcceleration', 0, 1);			sliderStoppingSpeed = new PropertySlider(mc.sliderStoppingSpeed, this, 'stoppingSpeed', 0, 2);
			
			mc.toogleAnim.addEventListener(MouseEvent.CLICK, onToogleAnim_Click);
			
			addTestKey(KeyCode.T, nofoo);
			
			draw();
		}

		private function draw():void {
			mc.toogleAnim.label = isInertial ? 'change to stopping' : 'change to inertial';
			mc.tfAnimType.htmlText = isInertial ? 'inertial' : 'stopping';
			sliderInertialFriction.container.alpha=isInertial ? 1 : 0.2;			sliderInterialAcceleration.container.alpha=isInertial ? 1 : 0.2;			sliderStoppingSpeed.container.alpha=isInertial ? 0.2 : 1;
		}

		private function tweenBallToClip(tragetClip:MovieClip):void {
			if(isInertial) {
				Tween.tweenInertialTo([[mc.ball, 'x', tragetClip.x], [mc.ball, 'y', tragetClip.y]], onTweenFinish, inertialFriction, inertialAcceleration);
			} else {
				Tween.tweenStoppingTo([[mc.ball, 'x', tragetClip.x], [mc.ball, 'y', tragetClip.y]], onTweenFinish, stoppingSpeed);
			}
		}

		private function nofoo():void {
			foo.finish();
			foo.dispose();
		}

		public function get inertialAcceleration():Number {
			return _inertialAcceleration;
		}

		public function set inertialAcceleration(value:Number):void {
			_inertialAcceleration = value;
		}

		public function get inertialFriction():Number {
			return _inertialFriction;
		}

		public function set inertialFriction(value:Number):void {
			_inertialFriction = value;
		}

		public function get stoppingSpeed():Number {
			return _stoppingSpeed;
		}

		public function set stoppingSpeed(value:Number):void {
			_stoppingSpeed = value;
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

		private function onToogleAnim_Click(event:MouseEvent):void {
			isInertial = !isInertial;
			draw();
		}
	}
}
