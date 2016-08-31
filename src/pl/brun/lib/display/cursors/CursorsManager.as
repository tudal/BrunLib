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
package pl.brun.lib.display.cursors {
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.Base;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.models.IDisplayObjectOperator;
	import pl.brun.lib.util.ArrayUtils;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;

	/**
	 * Check class:
	 * pl.brun.lib.test.display.button.view.cursorButtonViews.DraggingCursorButtonViewClassTest
	 * for tests
	 * 
	 * @author Marek Brun
	 */
	public class CursorsManager extends Base {

		static private var instance:CursorsManager;
		private var holder:Sprite;
		private var dictRequester_RequesterCursors:Dictionary /* * and RequesterCursors */= new Dictionary(true);
		private var currentCursor:Cursor;
		private var _isCursor:Boolean;
		private const requestsTMP:Array /*of CursorRequest*/= [];
		private const highestRankRequests:Array /*of CursorRequest*/= [];

		public function CursorsManager(access:Private) {
			holder = new Sprite();
			holder.mouseChildren = false;			holder.mouseEnabled = false;
		}

		/**
		 * @param requester - normally that will be the object that want specifed cursor
		 * If requester is gone from memory by GC then it's cursor also be gone
		 * with next refresh (automatically if it is instance of Base class).
		 */
		public static function show(requester:*, cursor:Cursor):void {
			getInstance().show_(requester, cursor);
		}

		public function show_(requester:*, cursor:Cursor):void {
			if(!dictRequester_RequesterCursors[requester]) {
				//first request from passed requester
				dictRequester_RequesterCursors[requester] = new RequesterCursors(requester);
				if(requester is Base) {
					Base(requester).addEventListener(EventPlus.BEFORE_DISPOSED, onRequester_Dispose);
				}
				if(requester is IDisplayObjectOperator) {
					IDisplayObjectOperator(requester).display.addEventListener(Event.REMOVED_FROM_STAGE, onRequester_RemovedFromStage, false, 0, true);
					IDisplayObjectOperator(requester).display.addEventListener(Event.ADDED_TO_STAGE, onRequester_AddedToStage, false, 0, true);
				}
			}
			var requesterCursors:RequesterCursors = dictRequester_RequesterCursors[requester];
			requesterCursors.addCursor(cursor);
			solveCurrentCursor();
		}

		public static function removeAllCursorsByRequester(requester:*):void {
			getInstance().removeAllCursorsByRequester_(requester);
		}

		public function removeAllCursorsByRequester_(requester:*):void {
			delete dictRequester_RequesterCursors[requester];
			solveCurrentCursor();
		}

		public static function hide(requester:*, cursor:Cursor):void {
			getInstance().hide_(requester, cursor);
		}

		public function hide_(requester:*, cursor:Cursor):void {
			if(!dictRequester_RequesterCursors[requester]) {
				return;
			}
			var requesterCursors:RequesterCursors = dictRequester_RequesterCursors[requester];
			requesterCursors.removeCursor(cursor);
			solveCurrentCursor();
		}

		/**
		 * Searching for cursor that should be currently showed
		 * First by rank, then by time of request.
		 */
		private function solveCurrentCursor():void {
			ArrayUtils.clear(requestsTMP)
			
			//getting all current requests
			var requesterCursors:RequesterCursors;
			var i:uint;
			for(var v:* in dictRequester_RequesterCursors) {
				requesterCursors = dictRequester_RequesterCursors[v];
				for(i = 0;i < requesterCursors.requests.length;i++) {
					requestsTMP.push(requesterCursors.requests[i])
				}
			}
			
			if(!requestsTMP.length) {
				removeCurrentCursor();
				ArrayUtils.clear(requestsTMP)
				return;
			}
			
			requestsTMP.sortOn('cursorRank', Array.NUMERIC | Array.DESCENDING);
			
			var highestRank:uint = requestsTMP[0].cursorRank;
			
			ArrayUtils.clear(highestRankRequests);
			
			//getting all cursors with highest rank
			var request:CursorRequest;
			for(i = 0;i < requestsTMP.length;i++) {
				request = requestsTMP[i];
				if(request.cursorRank < highestRank) {
					break;
				}
				if(request.requesterCursors.isRequesterAtStage) {
					highestRankRequests.push(request);
				}
			}
			ArrayUtils.clear(requestsTMP)
			if(!highestRankRequests.length) {
				removeCurrentCursor();
				return;
			}
			
			//there can be multiple cursors with the same rank
			//in this case time decide about which cursor will be choosed
			//(higher time - better)
			highestRankRequests.sortOn('time', Array.NUMERIC | Array.DESCENDING);
			
			showCursor(CursorRequest(highestRankRequests[0]).cursor);
		}

		private function showCursor(cursor:Cursor):void {
			if(currentCursor == cursor) {
				return;
			}
			removeCurrentCursor();			currentCursor = cursor;
			holder.addChild(currentCursor.container);
			isCursor = true;
		}

		private function removeCurrentCursor():void {
			if(currentCursor) {
				holder.removeChild(currentCursor.container);
				currentCursor = null;
				isCursor = false;
			}
		}

		public function get isCursor():Boolean {
			return _isCursor;
		}

		public function set isCursor(value:Boolean):void {
			if(_isCursor == value) {
				return;
			}
			_isCursor = value;
			if(isCursor) {
				StageProvider.getStage().addChild(holder);
				StageProvider.getStage().addEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove_WhileCursor, false, 0, true);
				refreshMove();
				Mouse.hide();
			} else {
				StageProvider.getStage().removeChild(holder);
				StageProvider.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, onStage_MouseMove_WhileCursor);
				Mouse.show();			}
		}

		private function refreshMove():void {
			holder.x = holder.parent.mouseX;
			holder.y = holder.parent.mouseY;
		}

		static public function getInstance():CursorsManager {
			if(instance) { 
				return instance; 
			} 
			instance = new CursorsManager(null);
			return instance;
		}

		//----------------------------------------------------------------------
		//	event handlers
		//----------------------------------------------------------------------
		private function onRequester_Dispose(event:EventPlus):void {
			removeAllCursorsByRequester_(event.target);
		}

		private function onRequester_AddedToStage(event:Event):void {
			solveCurrentCursor();
		}

		private function onRequester_RemovedFromStage(event:Event):void {
			solveCurrentCursor();
		}

		private function onStage_MouseMove_WhileCursor(event:MouseEvent):void {
			refreshMove();
		}
	}
}
import pl.brun.lib.display.cursors.Cursor;
import pl.brun.lib.models.IDisplayObjectOperator;
import pl.brun.lib.util.ArrayUtils;

import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

internal class Private {
}

class RequesterCursors {

	public var isRequesterAtStage:Boolean = true;
	protected var _requests:Array /*of CursorRequest*/= [];
	protected var dictCursor_Request:Dictionary /*Cursor and CursorRequest*/= new Dictionary();

	public function RequesterCursors(requester:*) {
		if(requester is IDisplayObjectOperator) {
			IDisplayObjectOperator(requester).display.addEventListener(Event.REMOVED_FROM_STAGE, onRequester_RemovedFromStage, false, 0, true);			IDisplayObjectOperator(requester).display.addEventListener(Event.ADDED_TO_STAGE, onRequester_AddedToStage, false, 0, true);
		}
	}

	public function addCursor(cursor:Cursor):void {
		var request:CursorRequest;
		if(!dictCursor_Request[cursor]) {
			dictCursor_Request[cursor] = new CursorRequest();
			request = dictCursor_Request[cursor];
			request.requesterCursors = this;
			request.cursor = cursor;			request.cursorRank = cursor.rank;				request.name = getQualifiedClassName(cursor).split('::')[1];
			_requests.push(request);
		}
		request = dictCursor_Request[cursor];		request.time = getTimer();
	}

	public function removeCursor(cursor:Cursor):void {
		if(dictCursor_Request[cursor]) {
			ArrayUtils.remove(requests, dictCursor_Request[cursor]);
			delete dictCursor_Request[cursor];	
		}
	}

	public function get requests():Array {
		return _requests;
	}

	//----------------------------------------------------------------------
	//	event handlers
	//----------------------------------------------------------------------
	private function onRequester_RemovedFromStage(event:Event):void {
		isRequesterAtStage = false;
	}

	private function onRequester_AddedToStage(event:Event):void {
		isRequesterAtStage = true;
	}
}

class CursorRequest {
	public function CursorRequest() {
	}


	public var requesterCursors:RequesterCursors;	public var cursorRank:uint;
	public var cursor:Cursor;	public var time:Number;	public var name:String;
}
