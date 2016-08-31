package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.tools.FrameDelayCall;
	import pl.brun.lib.util.ClassUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Marek Brun
	 */
	public class BDVariablesModel extends Base implements IBDTextContentProvider, IBDRefreshable {

		private var text:String = '';
		private var links:BDTextsManager;
		private var objRID:uint;

		public function BDVariablesModel(obj:Object, links:BDTextsManager) {
			this.links = links;
			objRID = links.weaks.getID(obj);
			FrameDelayCall.addCall(refresh);
		}

		public function getText():String {
			return text;
		}

		public function refresh():void {
			var lines:Array /*of String*/= [];
			
			var obj:Object = links.weaks.getValue(objRID);
			
			if(obj is IDisposable && IDisposable(obj).isDisposed){
				lines.push("instance disposed");
			}else{
				
				var publicFields:Dictionary = new Dictionary();
				
				var typeXML:XML = describeType(obj);
				var i:uint;
				var type:Type;
				var types:Array /*of Type*/ = [];
				var typesDict:Dictionary = new Dictionary();
				
				type = new Type(typeXML.@name);
				types.push(type);
				typesDict[typeXML.@name.toString().split('::').join('.')] = type;
				for(i = 0;i < typeXML.variable.length();i++) {
					if(typeXML.@variable == "writeonly") { 
						continue; 
					}
					type.accessors.push(typeXML.variable[i].@name.toString());
					publicFields[typeXML.variable[i].@name.toString()] = true;
				}
				
				for(i = 0;i < typeXML.extendsClass.length();i++) {
					type = new Type(typeXML.extendsClass[i].@type);
					types.push(type);
					typesDict[typeXML.extendsClass[i].@type.toString().split('::').join('.')] = type;
				}
				
				for(i = 0;i < typeXML.accessor.length();i++) {
					if(typeXML.accessor[i].@access == "writeonly") { 
						continue; 
					}
					type = typesDict[typeXML.accessor[i].@declaredBy.toString().split('::').join('.')];
					type.accessors.push(typeXML.accessor[i].@name.toString());
				}
				
				var j:uint;
				for(i = 0;i < types.length;i++) {
					type = types[i];
					lines.push(links.formatClassName(ClassUtils.getClassNameByQualified(type.name)));
					type.accessors.sort();
					for(j = 0;j < type.accessors.length;j++) {
						try{
							obj[type.accessors[j]]
						}catch(error:Error){
							continue
						}
						lines.push('   ' + links.formatFieldName(type.accessors[j] + ' = ' + links.createLink(obj[type.accessors[j]])));
						publicFields[type.accessors[j].toString()] = true;
					}
				}
			}
  			
			text = lines.join('\n');
			//XML.prettyPrinting = true;
			//text = Debugger.getInstance().link(typeXML.toString());
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}

class Type {

	public var name:String;
	public var accessors:Array = [];

	public function Type(name:String) {
		this.name = name;
	}
}