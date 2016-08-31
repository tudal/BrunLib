package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.model.services.BDObjectLogging;

	/**
	 * created: 2010-01-12
	 * @author Marek Brun
	 */
	public interface IBDObjectLoggingProvider {

		function get logging():BDObjectLogging;
		
	}
}
