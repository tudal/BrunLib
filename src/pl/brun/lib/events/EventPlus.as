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
package pl.brun.lib.events {
	import flash.events.Event;

	/**
	 * [Event(name="beforeDisposed", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="close", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="closeRequest", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="open", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="openRequest", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="mouseLeave", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="mouseLeave", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="mouseArrive", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="next", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="prev", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="nextRequest", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="prevRequest", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="response", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="responseRequest", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="submit", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="execute", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="removeRequest", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="restartRequest", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="ready", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="update", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="yes", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="no", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="pass", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="fail", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="rejected", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="activate", type="pl.brun.lib.events.EventPlus")]	 * [Event(name="deactivate", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="init", type="pl.brun.lib.events.EventPlus")]
	 * [Event(name="refresh", type="pl.brun.lib.events.EventPlus")]
	 * 
	 * Just collection of no param events.
	 * 
	 * @author Marek Brun
	 */
	public class EventPlus extends Event {
		/**
		 * Instance is now unused and should be prepared for grabbing by garbage collector.
		 * All added listeners is removed.
		 * Please remove reference for that instance.
		 */
		public static const BEFORE_DISPOSED:String = 'beforeDisposed';
		public static const CLOSE:String = 'close';
		public static const CANCEL:String = 'cancel';
		public static const CLOSE_REQUEST:String = 'closeRequest';
		public static const OPEN:String = 'open';
		public static const OPEN_REQUEST:String = 'openRequest';
		public static const MOUSE_LEAVE:String = 'mouseLeave';
		public static const MOUSE_ARRIVE:String = 'mouseArrive';
		public static const NEXT:String = 'next';
		public static const NEXT_REQUST:String = 'nextRequest';
		public static const PREV:String = 'prev';
		public static const PREV_REQUEST:String = 'prevRequest';
		public static const RESPONSE:String = 'response';
		public static const RESPONSE_REQUEST:String = 'responseRequest';
		public static const SUBMIT:String = 'submit';
		public static const EXECUTE:String = 'execute';
		public static const REMOVE_REQUEST:String = 'removeRequest';
		public static const RESTART_REQUEST:String = 'restartRequest';
		public static const RESTART:String = 'restart';
		public static const READY:String = 'ready';
		public static const LENGTH_CHANGED:String = 'lengthChanged';
		public static const UPDATE:String = 'update';
		public static const YES:String = 'yes';
		public static const NO:String = 'no';
		public static const PASS:String = 'pass';
		public static const FAIL:String = 'fail';
		public static const BEFORE_FLUSH:String = 'beforeFlush';
		public static const SUCCESS:String = 'success';
		public static const REJECTED:String = 'rejected';
		public static const ACTIVATE:String = 'activatee';
		public static const DEACTIVATE:String = 'deactivatee';
		public static const INITT:String = 'initt';
		public static const REFRESH:String = 'refresh';
		public static const INTERACTION_START:String = "interactionStart";
		public static const INTERACTION_STOP:String = "interactionStop";
		public static const LOG_OUT:String = "logOut";
		public static const ZOOM:String = "zoom";
		public static const CONNECT:String = 'connect';
		public static const DISCONNECT:String = 'disconnect';
		public static const DATA:String = 'data';

		public function EventPlus(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

		override public function clone():Event {
			return new EventPlus(type);
		}
	}
}
