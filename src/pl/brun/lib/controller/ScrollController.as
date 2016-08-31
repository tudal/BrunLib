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
package pl.brun.lib.controller {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.PositionEvent;
	import pl.brun.lib.models.IScrollable;
	import pl.brun.lib.models.IScroller;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class ScrollController extends Base {

		private var view:IScroller;
		private var model:IScrollable;

		public function ScrollController(model:IScrollable, view:IScroller) {
			this.model = model;
			this.view = view;
			
			addEventSubscription(view, PositionEvent.POSITION_REQUEST, onView_PositionRequest);
			addEventSubscription(model, PositionEvent.POSITION_CHANGED, onModel_PositionChanged);
			
			view.setScroll(model.getScroll(), model.getVisibleArea(), model.getTotalArea());
		}

		override public function dispose():void {
			model = null;			view = null;
			super.dispose();
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onView_PositionRequest(event:PositionEvent):void {
			model.setScroll(event.position);
		}

		private function onModel_PositionChanged(event:PositionEvent):void {
			view.setScroll(event.position, model.getVisibleArea(), model.getTotalArea());
		}
	}
}
