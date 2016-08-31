/*
 * Copyright 2009 Marek Brun
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *    
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package pl.brun.lib.util {
	import flash.utils.getQualifiedClassName;
	import pl.brun.lib.IDisposable;

	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Marek Brun
	 */
	public class ClassUtils {

		/**
		 * Store class definition variables names for reuse
		 * 
		 * keys:Function //classes constructor
		 * values: Vector.<String> //of variable name
		 */
		static private const dictClass_Variables:Dictionary = new Dictionary(true);

		/**
		 * @return Array of String
		 */
		static public function getVariableNames(obj:Object):Array {
			if(!dictClass_Variables[obj.constructor]) {
				var typeXML:XML = describeType(obj);
				var i:uint;
				
				var variableNames:Array /*of String*/ = [];
				for(i = 0;i < typeXML.variable.length();i++) {
					variableNames.push(typeXML.variable[i].@name);
				}
				dictClass_Variables[obj.constructor] = variableNames;
			}
			
			return dictClass_Variables[obj.constructor];
		}

		public static function getClassNameByObject(obj:Object):String {
			return getClassNameByQualified(getQualifiedClassName(obj))
		}
		public static function getClassNameByQualified(qualifiedClassName:String):String {
			if(qualifiedClassName.indexOf('::') == -1) {
				return StringUtils.safeHTML(qualifiedClassName);
			}
			return StringUtils.safeHTML(qualifiedClassName.split('::')[1]);
		}

		public static function disposeAllInArray(arr:Array/*of IDisposable*/):void {
			if(!arr) { 
				return; 
			}
			var i:uint;
			var obj:IDisposable;
			for(i = 0;i < arr.length;i++) {
				obj = arr[i];
				obj.dispose()
			}
		}
	}
}
