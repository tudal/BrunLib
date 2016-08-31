package pl.brun.lib.debugger.managers {
	import pl.brun.lib.Base;
	import pl.brun.lib.debugger.BDLinkEvent;
	import pl.brun.lib.debugger.BDLinkVO;
	import pl.brun.lib.models.WeakReferences;
	import pl.brun.lib.util.ClassUtils;
	import pl.brun.lib.util.StringUtils;

	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	/**
	 * Take care of:
	 *  - HTML formatting of Objects
	 *  - HTML links
	 * 
	 * Events:
	 *  - BDLinkEvent.LINK_CALL
	 * 
	 * created: 2009-12-26
	 * @author Marek Brun
	 */
	public class BDTextsManager extends Base {
		private var longStrings:Dictionary = new Dictionary();
		private var idCount:uint = 0;
		private var _weaks:WeakReferences;
		private var remembered:Array = [];
		private var storeFuncs:Array = [];
		private var longStringLength:uint = 60;

		public function BDTextsManager(weaks:WeakReferences) {
			this._weaks = weaks;
		}

		public function formatClassName(className:String):String {
			return '<b><FONT FACE="Georgia" SIZE="10" COLOR="#7F0055">' + className + '</FONT></b>';
		}

		public function formatClassNameByQualified(className:String):String {
			return formatClassName(ClassUtils.getClassNameByQualified(className));
		}

		public function formatMethodName(methodName:String):String {
			return '<FONT FACE="Georgia" SIZE="10" COLOR="#005980">' + methodName + '</FONT>';
		}

		public function formatClassByObject(obj:Object):String {
			var name:String = formatClassName(ClassUtils.getClassNameByQualified(getQualifiedClassName(obj)));
			try {
				if (obj.hasOwnProperty && obj.hasOwnProperty('name') && obj.name is String) {
					name += '(' + obj.name + ')';
				} else if (obj.hasOwnProperty('id') && obj.id is String) {
					name += '(' + obj.id + ')';
				} else if (obj.hasOwnProperty('ID') && obj.ID is String) {
					name += '(' + obj.ID + ')';
				} else if (obj.hasOwnProperty('dbgName') && obj.dbgName is String && obj.dbgName.length) {
					name += '(' + obj.dbgName + ')';
				}
			} catch(e:*) {
			}
			return name;
		}

		public function color(text:String, color:uint):String {
			return '<FONT COLOR="#' + color.toString(16) + '">' + text + '</FONT>';
		}

		public function formatFieldName(name:String):String {
			// return '<b>' + name + '</b>';
			return name;
		}

		public function createLink(value:*, isRemember:Boolean = false, desc:String = null):String {
			if (value == null) {
				return 'null';
			}
			if (value is Number || value is uint || value is int) {
				return color(value, 0x008000);
			}
			if (value is String) {
				if (String(value).length > 40) {
					return createStringLink(value);
				}
				return color('„' + StringUtils.safeHTML(value) + '”', 0x008000);
			}
			if (value is Boolean) {
				return color(String(value), 0x7F0055);
			}

			if (value is Object) {
				if (isRemember) {
					remembered.push(value)
					if (remembered.length > longStringLength) {
						remembered.shift()
					}
				}
				var referenceID:uint = _weaks.getID(value);
				if (desc == null) {
					if (value is Date) {
						desc = 'Date (' + value.toString() + ')';
					} else {
						desc = formatClassByObject(value);
					}
				}
				return createHTMLLink(BDLinkVO.TYPE_OBJECT, String(referenceID), desc);
			}

			return String(value);
		}

		private function createStringLink(string:String):String {
			longStrings[++idCount] = string;
			return createHTMLLink(BDLinkVO.TYPE_LONG_STRING, String(idCount), color('„' + StringUtils.safeHTML(String(string).substr(0, longStringLength)) + '[…]”', 0x008000)) + color('(' + string.length + ')', 0xCCCCCC);
		}

		public function createExeLink(func:Function, desc:String):String {
			storeFuncs.push(func);
			var referenceID:uint = _weaks.getID(func);
			return createHTMLLink(BDLinkVO.TYPE_EXE, String(referenceID), desc);
		}

		private function createHTMLLink(type:String, value:String, desc:String):String {
			return '<A HREF="event:' + type + ',' + value + '">' + desc + '</A></U>';
		}

		public function registerTextFieldWithLinks(tf:TextField):void {
			tf.addEventListener(TextEvent.LINK, onTextField_Link);
		}

		public function get weaks():WeakReferences {
			return _weaks;
		}

		// ----------------------------------------------------------------------
		// event handlers
		// ----------------------------------------------------------------------
		private function onTextField_Link(event:TextEvent):void {
			var link:BDLinkVO = new BDLinkVO();
			link.type = event.text.split(',')[0];

			switch(event.text.split(',')[0]) {
				case BDLinkVO.TYPE_LONG_STRING:
					link.value = longStrings[uint(event.text.split(',')[1])];
					break;
				case BDLinkVO.TYPE_EXE:
					link.value = _weaks.getValue(uint(event.text.split(',')[1]));
					break;
				case BDLinkVO.TYPE_OBJECT:
					link.value = _weaks.getValue(uint(event.text.split(',')[1]));
					break;
				// default:
				// throw new IllegalOperationError('Unsupported link type:' + event.text.split(',')[0]);
			}
			dispatchEvent(new BDLinkEvent(BDLinkEvent.LINK_CALL, link));
			link.type = null;
			link = null;
		}
	}
}
