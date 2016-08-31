package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * created: 2010-01-11
	 * @author Marek Brun
	 */
	public class BDDisplayInfoModel extends Base implements IBDRefreshable, IBDTextContentProvider, IBDContentProvider {

		private var links:BDTextsManager;
		private var displayRID:uint;

		public function BDDisplayInfoModel(display:DisplayObject, links:BDTextsManager) {
			this.links = links;
			displayRID = links.weaks.getID(display);
		}

		public function refresh():void {
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getText():String {
			var display:DisplayObject = links.weaks.getValue(displayRID);
			if(!display){
				return '(no display in memory)';
			}
			
			var lines:Array /*of String*/= [];
			lines.push(DisplayUtils.getPatch(display).join('.'));			lines.push('');			if(display.parent) {
				lines.push('parent:' + links.createLink(display.parent));
			} else {
				lines.push('(no parent)');
			}
			lines.push('');
			if(display.stage) {
				lines.push('on stage');
			} else {
				lines.push('out of stage');
			}			lines.push('');
			if(display is DisplayObjectContainer) {
				var children:Array /*of DisplayObject*/= DisplayUtils.getChildren(DisplayObjectContainer(display));
				lines.push(children.length + ' children');
				var i:uint;
				var child:DisplayObject;
				for(i = 0;i < children.length;i++) {
					child = children[i];
					lines.push('	' + i + ':' + links.createLink(child));
				}
			}
			
			return lines.join('\n');
		}
	}
}
