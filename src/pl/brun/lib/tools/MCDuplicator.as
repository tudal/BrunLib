package pl.brun.lib.tools {
	import pl.brun.lib.Base;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Marek Brun
	 */
	public class MCDuplicator extends Base {
		private var duplicatedMC:MovieClip;
		private var dupliationsCount:Number=0;
		private var mc_parent:DisplayObjectContainer;

		public function MCDuplicator(duplicatedMC:MovieClip, parent:DisplayObjectContainer=null) {
			mc_parent=parent;
			if(getQualifiedClassName(mcClass)=="flash.display::MovieClip"){
				throw new Error("Please create class name for that instance ("+duplicatedMC.parent.name+'.'+duplicatedMC.name+")");
			}
			var newMC:MovieClip=MovieClip(new mcClass());
			newMC.name=duplicatedMC.name+'Copy'+dupliationsCount;
			if(addToParent){
				mc_parent.addChild(newMC);
			}
			return newMC;