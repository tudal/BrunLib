package pl.brun.lib.test.actions {
	import flash.display.MovieClip;

	import pl.brun.lib.util.DisplayUtils;
	import pl.brun.lib.actions.Action;
	import pl.brun.lib.util.KeyCode;

	import actionTest_fla.root.ContainerMC;

	import pl.brun.lib.test.TestBase;

	/**
	 * @author Jaros�aw �o�nowski
	 */
	public class ActionTest extends TestBase {
		private var mc:ContainerMC;
		private var roller:AnimationAction;
		private var jumper:AnimationAction;
		private var rot:Action;
		private var js:Array;
		private var szatanAction:SzatanAction;

		override protected function init():void {
			super.init();

			mc = new ContainerMC()
			addChild(mc)

			roller = new AnimationAction(mc.roller)
			jumper = new AnimationAction(mc.jumper)

			var jMCs:Array = DisplayUtils.getChildrenByPostfixCount(mc, 'j')
			js = []
			var j:AnimationAction
			for each(var jMC:MovieClip in jMCs) {
				j = new AnimationAction(jMC)
				js.push(j)
				jumper.addChildAction(j)
			}

			rot = new Action()
			rot.addChildAction(roller)
			jumper.parent = rot
			
			szatanAction = new SzatanAction("szatan")
			szatanAction.parent = js[1]

			addTestKey(KeyCode.n1, roller.start, null, "roller start")
			addTestKey(KeyCode.n2, roller.finish, null, "roller finish")

			addTestKey(KeyCode.n3, jumper.start, null, "jumper start")
			addTestKey(KeyCode.n4, jumper.finish, null, "jumper finish")

			addTestKey(KeyCode.A, js[0].start, null, "j[0] start")
			addTestKey(KeyCode.S, js[1].start, null, "j[1] start")
			addTestKey(KeyCode.D, js[2].start, null, "j[2] start")

			addTestKey(KeyCode.Z, szatanAction.start, null, "szatan action")
		}
	}
}
import flash.events.TimerEvent;
import flash.utils.Timer;
import pl.brun.lib.actions.Action;

import flash.display.MovieClip;
import flash.events.Event;

class AnimationAction extends Action {
	private var mc:MovieClip;
	private var timer:Timer;

	public function AnimationAction(mc:MovieClip) {
		this.mc = mc
		mc.gotoAndStop(1)

		mc.addEventListener("end", onMc_End)
		
		timer = new Timer(1000, 1)
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer_Complete)
	}

	private function onTimer_Complete(event:TimerEvent):void {
		readyToStart()
	}
	
	
	override protected function prepareToStart():void {
		timer.start()
	}
	
	override protected function canBeStarted():Boolean {
		return  timer.currentCount > 0
	}

	public function onMc_End(event:Event):void {
		if(!isRunningFlag) finish();
	}

	override protected function canBeFinished():Boolean {
		return mc.currentFrame == mc.totalFrames;
	}

	override protected function doRunning():void {
		mc.play()
	}

	override protected function doIdle():void {
		mc.gotoAndStop(1)
	}
}

class SzatanAction extends Action {
	private var txt:String;
	private var timer:Timer;
	public function SzatanAction(txt:String) {
		this.txt = txt
		
		timer = new Timer(1000, 2)
		timer.addEventListener(TimerEvent.TIMER, onTimer_Timer)		timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer_Complete)
		
	}

	private function onTimer_Complete(event:TimerEvent):void {
		finish()
	}
	
	override protected function canBeFinished():Boolean {
		return !timer.running
	}

	private function onTimer_Timer(event:TimerEvent):void {
		dbg.log("txt:"+dbg.link(txt, true))
	}	
	override protected function doRunning():void {
		dbg.log("txt:"+dbg.link(txt, true))
		timer.start()
	}
	
	

}
