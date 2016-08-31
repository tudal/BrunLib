package pl.brun.lib.models {
	/**
	 * @author Marek Brun
	 */
	public interface IExportImport {
		function export():Object;

		function importt(obj:Object):void;
	}
}
