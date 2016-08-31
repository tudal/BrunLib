package pl.brun.lib.debugger.creation {
	import pl.brun.lib.Base;
	import pl.brun.lib.IDisposable;
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;
	import pl.brun.lib.debugger.display.content.BDTextContent;
	import pl.brun.lib.debugger.managers.BDTextsManager;
	import pl.brun.lib.debugger.model.content.BDLoggerModel;
	import pl.brun.lib.debugger.model.content.BDMethodsModel;
	import pl.brun.lib.debugger.model.content.BDObjectFieldsModel;
	import pl.brun.lib.debugger.model.content.BDValuesLoggerModel;
	import pl.brun.lib.debugger.model.content.BDVariablesModel;
	import pl.brun.lib.debugger.model.services.BDCustomDebugService;
	import pl.brun.lib.debugger.model.services.BDObjectLogging;
	import pl.brun.lib.debugger.windows.BDMainWindow;
	import pl.brun.lib.util.ClassUtils;

	import flash.utils.getQualifiedClassName;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public class BDComplexDebugServiceCreation implements IBDDebugServiceCreation, IBDObjectLoggingProvider {

		private var _logging:BDObjectLogging;
		private var service:BDCustomDebugService;

		public function BDComplexDebugServiceCreation(obj:Object, links:BDTextsManager, mainLogger:BDMainWindow) {
			var title:String = ClassUtils.getClassNameByQualified(getQualifiedClassName(obj));
			
			var modelsDisposeParent:Base = new Base();
			
			var log:BDLoggerModel = new BDLoggerModel();
			var logView:BDTextContent = new BDTextContent('log', log, links);
			logView.isScrollToDown = true
			
			var values:BDValuesLoggerModel = new BDValuesLoggerModel(links);
			var valuesView:BDTextContent = new BDTextContent('values', values, links);
			
			var variables:BDVariablesModel = new BDVariablesModel(obj, links);
			var variablesView:BDTextContent = new BDTextContent("var", variables, links);
			
			var methods:BDMethodsModel = new BDMethodsModel(obj, links);
			var methodsView:BDTextContent = new BDTextContent("methods", methods, links);
			
			var fields:BDObjectFieldsModel = new BDObjectFieldsModel(obj, links);
			var fieldsView:BDTextContent = new BDTextContent('fields', fields, links);
			
			modelsDisposeParent.addDisposeChildren([log, values, variables, methods, fields]);			modelsDisposeParent.addDisposeChildren([logView, valuesView, variablesView, methodsView, fieldsView]);
			
			var contents:Array /*of BDAbstractContent*/ = [variablesView, methodsView, logView, valuesView, fieldsView];
			
			_logging = new BDObjectLogging(obj, log, values, links, mainLogger);
			
			service = new BDCustomDebugService(title, contents, links.weaks, obj);
			service.addDisposeChild(modelsDisposeParent);
			
			if(obj is IDisposable) {
				IDisposable(obj).addDisposeChild(service);
			}
		}

		public function get windowContentProvider():IBDWindowContentProvider {
			return service;
		}

		public function get logging():BDObjectLogging {
			return _logging;
		}
	}
}
