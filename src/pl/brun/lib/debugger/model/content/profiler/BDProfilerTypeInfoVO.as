package pl.brun.lib.debugger.model.content.profiler {

	/**
	 * @author Marek Brun
	 */
	public class BDProfilerTypeInfoVO {

		public var isCatchNextStack:Boolean;		public var catchNextStackCount:uint;		public const catchNextStackCountStart:uint = 6;		public var typeClass:Class;
		public var name:String;
		public var count:uint;
		public var size:int;
		public var link:String;
		public var catchStackLink:String;		public var catchedStacks:Array=[];

		public function BDProfilerTypeInfoVO(typeClass:Class) {
			this.typeClass = typeClass;
			name = String(typeClass).substr('[class '.length, String(typeClass).length - '[class '.length - 1);
		}

		public function catchNextStack():void {
			isCatchNextStack = true;
			catchNextStackCount = catchNextStackCountStart;
		}
	}
}
