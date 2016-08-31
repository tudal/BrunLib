package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.commands.CallCmd;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.service.FTS;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author Marek Brun
	 */
	public class BDSpeedTestModel extends Base implements IBDTextContentProvider,IBDClearable {
		private var dictID_Test:Dictionary = new Dictionary();
		private var tests:Vector.<Testt>=new <Testt>[];
		private var fts:FTS;
		private var clearLink:String;

		public function BDSpeedTestModel(links:BDTextsManager) {
			clearLink = links.createExeLink(clear, "clear")
			fts = FTS.getInstance()
			root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame)
		}

		private function onStage_EnterFrame(event:Event):void {
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function start(id:String):void {
			getTest(id).start()
		}

		public function finish(id:String):void {
			getTest(id).finish()
		}

		private function getTest(id:String):Testt {
			if (!dictID_Test[id]) {
				dictID_Test[id] = new Testt(id, new CallCmd(changed));
				tests.push(dictID_Test[id])
			}
			return Testt(dictID_Test[id])
		}

		private function changed():void {
			dispatchEvent(new Event(Event.CHANGE))
		}

		public function getText():String {
			var ft:Number = fts.getAverageFrameTime()
			var texts:Array = []
			for each (var test:Testt in tests) {
				texts.push(test.results(ft))
			}
			texts.sort()
			return '<b>'+clearLink+'</b>\n' + texts.join('\n');
		}

		public function clear():void {
			dictID_Test = new Dictionary()
			tests = new <Testt>[]
		}
	}
}
import pl.brun.lib.Base;
import pl.brun.lib.commands.ICommand;
import pl.brun.lib.tools.Averager;

import flash.utils.getTimer;

class Testt extends Base {
	private var isStarted:Boolean;
	private var timeAv:Averager;
	private var totalTime:uint;
	private var totalCount:uint;
	private var frameTotal:uint;
	private var frameTotalAv:Averager;
	private var frameCount:uint;
	private var frameCountMax:uint;
	private var frameCountAv:Averager;
	private var lastTime:int;
	private var timeMax:int;
	private var changeCmd:ICommand;
	private var id:String;
	private var totalMax:Number = 0;

	public function Testt(id:String, changeCmd:ICommand) {
		this.id = id;
		this.changeCmd = changeCmd;
		timeAv = new Averager()
		frameTotalAv = new Averager()
		frameCountAv = new Averager()
	}

	public function start():void {
		if (isStarted) return;
		totalCount++
		isStarted = true
		frameCount++
		lastTime = getTimer()
	}

	public function finish():void {
		if (!isStarted) return;
		isStarted = false
		lastTime = getTimer() - lastTime
		timeMax = Math.max(lastTime, timeMax)
		frameTotal += lastTime
		totalTime += lastTime
	}

	public function results(frameTime:Number):String {
		frameTotalAv.push(frameTotal)
		frameCountAv.push(frameCount)
		frameCountMax = Math.max(frameCount, frameCountMax)

		var total:Number = Math.round(frameTotalAv.getAverage() / frameTime * 100)
		totalMax = Math.max(total, totalMax)
		var result:String = '<b>' + id + '</b> last:'+lastTime+' frame count:' + frameCountAv.getAverage().toFixed(2) + '(max:' + frameCountMax + ') total:' + (total) + '% (max:' + totalMax + '%) '+totalCount

		frameTotal = 0
		frameCount = 0

		return result
	}
}