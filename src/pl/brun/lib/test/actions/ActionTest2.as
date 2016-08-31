package pl.brun.lib.test.actions {
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionsQueue;
	import pl.brun.lib.actions.tools.MultiActions;
	import pl.brun.lib.test.TestBase;
	import pl.brun.lib.util.KeyCode;

	import flash.display.Sprite;

	/**
	 * @author Jaros�aw �o�nowski
	 */
	public class ActionTest2 extends TestBase {
		private var actions:Array;
		private var rot:Action;
		private var queue:ActionsQueue;
		private var multiAction:MultiActions;

		override protected function init():void {
			super.init();
			actions = []

			var objNumber:Number = 5
			var animAction:AnimAction2

			rot = new Action()

			queue = new ActionsQueue()

			for(var i:uint; i < objNumber; i++) {
				var obj:Sprite = new Sprite()
				obj.graphics.beginFill(0x000000)
				obj.graphics.drawRect(-10, -10, 20, 20)
				obj.x = i * 60 + 100
				obj.y = 200
				obj.graphics.endFill()
				addChild(obj)

				animAction = new AnimAction2(obj, 100 + Math.random() * 600, Math.random() * 860)
				//rot.addChildAction(animAction)

				actions.push(animAction)
				addTestKey(KeyCode.n1 + i, animAction.start, null, "anim " + i + " start")
				//queue.addAction(animAction)
			}

			multiAction = new MultiActions([actions[0], actions[2], actions[3]])
			multiAction.parent = rot
			actions[1].parent = rot

			addTestKey(KeyCode.Q, queue.start, null, "queue.start")
			addTestKey(KeyCode.M, multiAction.start, null, "multiAction.start")
			addTestKey(KeyCode.N, multiAction.finish, null, "multiAction.finish")
			addTestKey(KeyCode.n1, actions[1].start, null, "actions[1].start")
		}
	}
}
import pl.brun.lib.actions.Action;
import pl.brun.lib.animation.dynamic_.AnimatedInertialNumber;
import pl.brun.lib.animation.dynamic_.AnimatedStoppingNumber;
import pl.brun.lib.service.FTS;

import flash.display.Sprite;
import flash.events.Event;

class AnimAction extends Action {
	private var mc:Sprite;
	private var fts:FTS;
	private var speed:Number = 0;
	private var acceleration:Number;
	private var targetSpeed:Number;

	public function AnimAction(mc:Sprite, acceleration:Number, targetSpeed:Number) {
		this.mc = mc
		this.targetSpeed = targetSpeed
		this.acceleration = acceleration
		fts = new FTS()
	}

	override protected function prepareToStart():void {
		mc.addEventListener(Event.ENTER_FRAME, onEvent_EnterFrame_WhileStart)
	}

	override protected function canBeStarted():Boolean {
		return speed == targetSpeed
	}

	override protected function canBeFinished():Boolean {
		return speed == 0
	}

	override protected function prepareToFinish():void {
		mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame_WhileRunning)
		mc.addEventListener(Event.ENTER_FRAME, onMC_EnterFrame_WhileFinish)
	}

	private function onMC_EnterFrame_WhileFinish(event:Event):void {
		speed -= acceleration * fts.getLastFrametimeInS01()
		mc.rotation += speed * fts.getLastFrametimeInS01()
		dbg.logv("speed", speed)
		if(speed < 0) {
			speed = 0
			mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame_WhileFinish)
			readyToFinish()
		}
	}

	override protected function doIdle():void {
		mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame_WhileFinish)
	}

	override protected function doRunning():void {
		mc.addEventListener(Event.ENTER_FRAME, onMC_EnterFrame_WhileRunning)
	}

	private function onMC_EnterFrame_WhileRunning(event:Event):void {
		mc.rotation += speed * fts.getLastFrametimeInS01()
	}

	private function onEvent_EnterFrame_WhileStart(event:Event):void {
		speed += acceleration * fts.getLastFrametimeInS01()
		mc.rotation += speed * fts.getLastFrametimeInS01()
		dbg.logv("speed", speed)
		dbg.logv("targetSpeed", targetSpeed)
		if(speed > targetSpeed) {
			speed = targetSpeed
			mc.removeEventListener(Event.ENTER_FRAME, onEvent_EnterFrame_WhileStart)
			readyToStart()
		}
	}
}
class AnimAction2 extends Action {
	public var speed:Number = 0;
	private var mc:Sprite;
	private var fts:FTS;
	private var acceleration:Number;
	private var targetSpeed:Number;
	private var starter:AnimatedInertialNumber;
	private var finisher:AnimatedStoppingNumber;

	public function AnimAction2(mc:Sprite, acceleration:Number, targetSpeed:Number) {
		this.mc = mc
		this.targetSpeed = targetSpeed
		this.acceleration = acceleration
		fts = new FTS()

		starter = new AnimatedInertialNumber()
		starter.addEventListener(Event.CHANGE, onStarter_Change)
		starter.target = targetSpeed

		finisher = new AnimatedStoppingNumber()
		finisher.addAutoMapping(this, "speed")
		finisher.target = 0
	}

	private function onStarter_Change(event:Event):void {
		speed = starter.current
	}

	override protected function doRunning():void {
		dbg.log("doRunning("+dbg.linkArr(arguments, true)+')')
		mc.addEventListener(Event.ENTER_FRAME, onMC_EnterFrame)
	}

	private function onMC_EnterFrame(event:Event):void {
		mc.rotation += speed * fts.getLastFrametimeInS01()
	}

	override protected function doIdle():void {
		mc.removeEventListener(Event.ENTER_FRAME, onMC_EnterFrame)
	}

	override protected function getInitialAction():Action {
		return starter;
	}

	override protected function getEndingAction():Action {
		return finisher;
	}

	override protected function doMiddleEnter():void {
		dbg.log("doMiddleEnter(" + dbg.linkArr(arguments, true) + ')')
		//setTimeout(finish, 1000)
	}

	override protected function doMiddleOut():void {
		dbg.log("doMiddleOut(" + dbg.linkArr(arguments, true) + ')')
	}
}

