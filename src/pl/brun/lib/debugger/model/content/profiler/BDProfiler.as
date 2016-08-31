package pl.brun.lib.debugger.model.content.profiler {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.IBDTextContentProvider;
	import pl.brun.lib.models.EasyCookie;
	import pl.brun.lib.models.ICookieDataProvider;

	import flash.events.Event;
	import flash.sampler.DeleteObjectSample;
	import flash.sampler.NewObjectSample;
	import flash.sampler.clearSamples;
	import flash.sampler.getSamples;
	import flash.sampler.getSize;
	import flash.sampler.pauseSampling;
	import flash.sampler.startSampling;
	import flash.utils.Dictionary;

	/**
	 * @author Marek Brun
	 */
	public class BDProfiler extends Base implements ICookieDataProvider, IBDTextContentProvider {

		private var dictClass_TypeInfo:Dictionary = new Dictionary();		private var dictSampleID_Type:Dictionary = new Dictionary();		private var dictSampleID_Size:Dictionary = new Dictionary();
		private var samplesInfo:String = '';
		private var typeInfos:Array /*of TypeInfo*/= [];
		private var texts:BDTextsManager;
		private var _isRunning:Boolean;
		private var cookie:EasyCookie;
		private var stackLines:Array /*of String*/= [];

		public function BDProfiler(texts:BDTextsManager) {
			this.texts = texts;
			
			cookie = new EasyCookie(this, 'BDProfiler');
		}

		public function clear():void {
			dictClass_TypeInfo = new Dictionary();
			dictSampleID_Type = new Dictionary();
			dictSampleID_Size = new Dictionary();
			typeInfos = [];
			samplesInfo = '(disabled)';
		}

		public function grabNewSamplesSeesion():void {
			pauseSampling();
			
			var lines:Array /*of String*/= [];
			
			var samples:Object = flash.sampler.getSamples();
			
			var sample:Object;
			var type:BDProfilerTypeInfoVO;
			var size:uint;
			var i:uint;
			for each(sample in samples) {
				if(sample is NewObjectSample) {
					if(!dictClass_TypeInfo[sample.type]) {
						dictClass_TypeInfo[sample.type] = new BDProfilerTypeInfoVO(sample.type);
						type = dictClass_TypeInfo[sample.type];
						type.link = texts.createLink(type, false, type.name);						type.catchStackLink = texts.createExeLink(type.catchNextStack, 'catch next');
						typeInfos.push(dictClass_TypeInfo[sample.type]);
					}
					
					type = dictClass_TypeInfo[sample.type];
					
					if(type.isCatchNextStack) catching: {
						if(!sample.stack){
							break catching;
						}
						for(i = 0;i < sample.stack.length;i++) {
							if(sample.stack[i].name.indexOf('pl.brun.lib.debugger') > -1) {
								break catching;
							}
							stackLines.push('line:' + sample.stack[i].line + ' ' + sample.stack[i].name);
						}
						type.catchedStacks.push('################### STACK:' + (type.catchedStacks.length + 1) + '\n' + stackLines.join('\n'));
						stackLines = [];
						if(type.catchedStacks.length > 10) {
							type.isCatchNextStack = false;
							dbg.showObj(type.catchedStacks.join('\n\n\n'));
							type.catchedStacks = [];
						}
					}
					dictSampleID_Type[sample.id] = type;
					
					size = getSize(sample);
					dictSampleID_Size[sample.id] = size;
					
					type.count++;
					
					type.size += size;
				}else if(sample is DeleteObjectSample) {					
					type = dictSampleID_Type[sample.id];
					delete dictSampleID_Type[sample.id];
					if(!type) {
						dbg.logv('profiler error');
						continue;
					}
					type.size -= dictSampleID_Size[sample.id];
					delete dictSampleID_Size[sample.id];
					type.count--;
				}
			}
			
			typeInfos.sortOn('size', Array.NUMERIC | Array.DESCENDING);
			
			var typeInfo:Object;
			for(i = 0;i < typeInfos.length;i++) {
				typeInfo = typeInfos[i];
				lines.push(typeInfo.count + ' of <b>' + typeInfo.link + '</b>   size:' + Math.round(typeInfo.size * 0.0009765625) + ' kilobytes   ' + typeInfo.catchStackLink);
			}
			
			
			samplesInfo = lines.join('\n');
			
			clearSamples();
			startSampling();
		}

		public function getText():String {
			return samplesInfo;
		}

		public function get isRunning():Boolean {
			return _isRunning;
		}

		public function set isRunning(value:Boolean):void {
			if(_isRunning == value) {
				return;
			}			_isRunning = value;
			if(_isRunning) {
				samplesInfo = '';
				typeInfos = [];
				startSampling();
				root.addEventListener(Event.ENTER_FRAME, onStage_EnterFrame, false, 0, true);			} else {
				root.removeEventListener(Event.ENTER_FRAME, onStage_EnterFrame);
				clear();
				samplesInfo = '(disabled)';
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function getSharedObjectInitData():Object {
			return {isRunning:false};
		}

		public function applySharedObjectData(data:Object):void {
			isRunning = data.isRunning;
		}

		public function getSharedObjectData():Object {
			return {
				isRunning:isRunning
			};
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onStage_EnterFrame(event:Event):void {
			grabNewSamplesSeesion();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}