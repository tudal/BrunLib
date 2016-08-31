package pl.brun.lib.display.button.views.cursorButtonViews {
	import pl.brun.lib.display.button.views.AbstractButtonView;
	import pl.brun.lib.display.cursors.Cursor;
	import pl.brun.lib.display.cursors.CursorsManager;

	/**
	 * @author Marek Brun
	 */
	public class CursorOverButtonView extends AbstractButtonView {

		private var cursor:Cursor;
		
		public function CursorOverButtonView(cursor:Cursor) {
			this.cursor = cursor;
		}
		
		override protected function doRollOver():void {
			CursorsManager.show(this, cursor);
		}
		
		override protected function doRollOut():void {
			CursorsManager.hide(this, cursor);
		}
	}
}
