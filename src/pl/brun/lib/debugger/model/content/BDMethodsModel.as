package pl.brun.lib.debugger.model.content {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.util.ClassUtils;

	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Marek Brun
	 */
	public class BDMethodsModel extends Base implements IBDTextContentProvider {

		private var text:String;
		private var methodsToStore:Array/*of Function*/;

		public function BDMethodsModel(obj:Object, links:BDTextsManager) {
			methodsToStore = [];
			
			var types:Array /*of Type*/= [];
			var typesDict:Dictionary = new Dictionary();
			
			var typeXML:XML = describeType(obj);
			
			var type:Type;
			type = new Type(typeXML.@name);
			types.push(type);
			typesDict[typeXML.@name.toString().split('::').join('.')] = type;
			
			var i:uint;
			for(i = 0;i < typeXML.extendsClass.length();i++) {
				type = new Type(typeXML.extendsClass[i].@type);
				types.push(type);
				typesDict[typeXML.extendsClass[i].@type.toString().split('::').join('.')] = type;
			}
			
			for(i = 0;i < typeXML.method.length();i++) {
				type = typesDict[typeXML.method[i].@declaredBy.toString().split('::').join('.')];
				type.methods.push(typeXML.method[i].@name.toString());
			}
			
			var lines:Array /*of String*/= [];
			
			var j:uint, n:uint;
			var method:String;			var methodText:String;			var methodXML:XML;			var paramXML:XML;
			var params:Array;			var func:Function;
			for(i = 0;i < types.length;i++) {
				type = types[i];
				lines.push(links.formatClassNameByQualified(type.name));
				type.methods.sort();
								
				for(j = 0;j < type.methods.length;j++) {
					method = type.methods[j];
					
					methodXML = typeXML.method.(@name == method)[0];
					
					methodText = links.formatMethodName(methodXML.@name) + '(';
					params = [];
					for(n = 0;n < methodXML.parameter.length();n++) {
						paramXML = methodXML.parameter[n];
						params.push(ClassUtils.getClassNameByQualified(paramXML.@type));
					}
					methodText += params.join(', ') + ')';
					methodText += ':' + ClassUtils.getClassNameByQualified(methodXML.@returnType);
					
					if(!params.length) {
						func = obj[methodXML.@name.toString()];
						methodsToStore.push(func);
						methodText += ' ' + links.createExeLink(func, 'exe');
					}
					
					lines.push('   ' + methodText);
				}
			}
			
			text = lines.join('\n');
			//			XML.prettyPrinting = true;			//			text = Debugger.getInstance().link(typeXML.toString());
			dispatchEvent(new Event(Event.CHANGE));
		}

		public function getText():String {
			return text;
		}
	}
}

class Type {

	public var name:String;
	public var methods:Array = [];

	public function Type(name:String) {
		this.name = name;
	}
}