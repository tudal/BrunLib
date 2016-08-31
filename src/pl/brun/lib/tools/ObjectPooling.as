package pl.brun.lib.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.GlobalDbg;
	import pl.brun.lib.models.IResetable;
	import pl.brun.lib.util.func.htmlRedB;

	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * Universal object poling for objects with no arguments in constructors.
	 * 
	 * @author Marek Brun
	 */
	public class ObjectPooling extends Base {

		private static var dictType_Pooling:Dictionary = new Dictionary();
		private var dictObj_IsRecycled:Dictionary = new Dictionary(true);
		private var Type:Class;
		private var bin:Vector.<Object>=new <Object>[];
		private var countToLog:uint = 1
		private var countRecycle:Number = 0
		private var countNew:Number = 0
		private var countGett:Number = 0
		private var name:String;
		private var cleanTimer:Timer;
		private var targetBinLength:uint;
		private var logTimer:Timer;
		public var binLimit:Number = 50000;

		public function ObjectPooling(Type:Class) {
			this.Type = Type
			name = String(Type)

			cleanTimer = new Timer(10000)
			cleanTimer.addEventListener(TimerEvent.TIMER, onCleanTimer_Timer)
			// cleanTimer.start()

			logTimer = new Timer(10000)
			logTimer.addEventListener(TimerEvent.TIMER, onLogTimer_Timer)
			logTimer.start()
		}

		private function onLogTimer_Timer(event:TimerEvent):void {
			logvNow()
		}

		private function onCleanTimer_Timer(event:TimerEvent):void {
			if (bin.length > 100) {
				targetBinLength = bin.length / 2
				while (bin.length > targetBinLength) {
					bin.pop()
				}
				logvNow()
			}
		}

		public function gett():* {
			countGett++
			logv()
			if (bin.length) {
				var obj:* = bin.pop();
				delete dictObj_IsRecycled[obj]
				if (obj is IResetable) IResetable(obj).reset();
				return obj
			}
			countNew++
			return new Type()
		}

		private function logv():void {
			countToLog--
			if (!countToLog) {
				countToLog = 100
				logvNow()
			}
		}

		private function logvNow():void {
			GlobalDbg.d.logv(' pool ' + name, 'inBin:' + bin.length + ' countRecycle:' + Math.floor(countRecycle) + ' countGett:' + Math.floor(countGett) + '  usedNow:' + Math.floor(countGett - countRecycle) + '  new:' + Math.floor(countNew))
		}

		public function recycle(obj:Object):void {
			if (bin.length > binLimit) return;
			// if (Object(obj).constructor != Type) throw new ArgumentError("Wrong class type of passed object");
			if (dictObj_IsRecycled[obj]) {
				//throw new ArgumentError("obj is already recycled");
				GlobalDbg.d.logv(' pool ' + name + ' ' + htmlRedB('WARN: obj is already recycled'))
			}
			dictObj_IsRecycled[obj] = true
			bin.push(obj)
			countRecycle++
			logv()
		}

		public function recycleArr(arr:*):void {
			if (bin.length > binLimit) return;
			for each (var obj:Object in arr) {
				// if (Object(obj).constructor != Type) throw new ArgumentError("Wrong class type of passed object");
				if (dictObj_IsRecycled[obj]) {
					//throw new ArgumentError("obj is already recycled");
					GlobalDbg.d.logv(' pool ' + name + ' ' + htmlRedB('WARN: obj is already recycled'))
				}
				dictObj_IsRecycled[obj] = true
				bin.push(obj)
				countRecycle++
			}
		}

		public function recycleArrPop(arr:Array):void {
			if (bin.length > binLimit) return;
			var obj:Object;
			while (arr.length) {
				obj = arr.pop()
				// if (Object(obj).constructor != Type) throw new ArgumentError("Wrong class type of passed object");
				if (dictObj_IsRecycled[obj]) {
					//throw new ArgumentError("obj is already recycled");
					GlobalDbg.d.logv(' pool ' + name + ' ' + htmlRedB('WARN: obj is already recycled'))
				}
				dictObj_IsRecycled[obj] = true
				bin.push(obj)
				countRecycle++
			}
		}

		public static function forType(type:Class):ObjectPooling {
			if (!dictType_Pooling[type]) dictType_Pooling[type] = new ObjectPooling(type);
			return ObjectPooling(dictType_Pooling[type])
		}
	}
}
