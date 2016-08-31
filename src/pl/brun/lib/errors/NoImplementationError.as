package pl.brun.lib.errors {
	import flash.errors.IllegalOperationError;

	/**
	 * 2011-04-10  05:03:23
	 * @author Marek Brun
	 */
	public class NoImplementationError extends IllegalOperationError {
		
		public function NoImplementationError(message:* = "No implementation") {
			super(message)
		}
		
	}
}
