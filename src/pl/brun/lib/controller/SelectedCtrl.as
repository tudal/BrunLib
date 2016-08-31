package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.SelectEvent;
	import pl.brun.lib.events.SelectIndexEvent;
	import pl.brun.lib.models.ISelectableModel;
	import pl.brun.lib.models.ISelectableView;

	/**
	 * created:2010-09-29  13:42:33
	 * @author Marek Brun
	 */
	public class SelectedCtrl extends Base {

		private var selectModel:ISelectableModel;
		private var selectViews:Array /*of ISelectable*/= [];
		private var currentSelected:ISelectableView;

		public function SelectedCtrl(selectModel:ISelectableModel, selectViews:Array/*of ISelectable*/) {
			this.selectViews = selectViews;
			this.selectModel = selectModel;
			var i:uint;
			var selectView:ISelectableView;
			for(i = 0;i < selectViews.length;i++) {
				selectView = selectViews[i];
				if(selectModel.getSelectByIndex() == i) {
					selectView.select();
					currentSelected = selectView;
				} else {
					selectView.deselect();
				}
				selectView.addEventListener(SelectEvent.SELECT_REQUEST, onSelectView_SelectRequest);
			}
			
			selectModel.addEventListener(SelectIndexEvent.SELECT, onSelectModel_Select);
		}

		////////////////////////////////////////////////////////////////////////
		private function onSelectModel_Select(event:SelectIndexEvent):void {
			if(currentSelected && selectViews[event.index] != currentSelected) {
				currentSelected.deselect();
			}
			currentSelected = selectViews[event.index];
			currentSelected.select();
		}

		private function onSelectView_SelectRequest(event:SelectEvent):void {
			selectModel.selectByIndex(selectViews.indexOf(event.target));
		}
	}
}
