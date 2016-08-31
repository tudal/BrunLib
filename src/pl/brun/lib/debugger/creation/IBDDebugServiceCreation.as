package pl.brun.lib.debugger.creation {
	import pl.brun.lib.debugger.display.IBDWindowContentProvider;

	/**
	 * created: 2010-01-10
	 * @author Marek Brun
	 */
	public interface IBDDebugServiceCreation {
		function get windowContentProvider():IBDWindowContentProvider;
	}
}
