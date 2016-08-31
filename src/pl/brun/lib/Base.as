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
package pl.brun.lib {
	import pl.brun.lib.debugger.DebugServiceProxy;
	import pl.brun.lib.debugger.SimpleLog;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.managers.RootProvider;
	import pl.brun.lib.managers.StageProvider;
	import pl.brun.lib.util.ArrayUtils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	[Event(name="beforeDisposed", type="pl.brun.lib.events.EventPlus")]
	/*
	You can use this regex to replace all addEventListener to addEventSubscription
	
	([\w_().]+)\.addEventListener\(([\w_()\s.]+), ([\w_()\s]+)\)
	addEventSubscription(\1, \2, \3)

	([\w_().]+)\.removeEventListener\(([\w_()\s.]+), ([\w_()\s]+)\)
	removeEventSubscription(\1, \2, \3)
	 */
	/**
	 * Base class offering extra dispose and events help features.
	 * Also creates debugger service proxy instance.
	 * 
	 * listener: this class - > event -> other class
	 * subscription: other class - > event -> this class
	 *  
	 * Events:
	 *  - BaseEvent.BEFORE_DISPOSED
	 * 
	 * @author Marek Brun
	 */
	public class Base extends EventDispatcher implements IDisposable {
		private var _isDisposed:Boolean;
		/**
		 * Store added listeners (events dipatched <b>from</b> this instance)
		 * 
		 * keys:String // event type
		 * values:Array of Function (handlers)
		 */
		private var listeners:Dictionary
		/**
		 * Store subscriptions (events dipatched <b>for</b> this instance)
		 * added by setupEventSubscription method
		 * 
		 * keys:String // event type
		 * values:Dictionary
		 * 	keys:IEventDispatcher
		 * 	values:Array of Function (handlers)
		 */
		private var subscriptions:Dictionary
		public var _dbg:DebugServiceProxy;
		private var disposeChildren:Array/*of IDisposable*/;
		public var dbgName:String;
		public var isDispatchBlocked:Boolean;

		public function Base() {
		}

		public function get dbg():DebugServiceProxy {
			if (!_dbg) {
				try {
					_dbg = DebugServiceProxy.forInstance(this);
				} catch(e:Error) {
					SimpleLog.log('creating dbg error')
					SimpleLog.log(e.message)
					SimpleLog.log(e.getStackTrace())
				}
			}
			return _dbg;
		}

		/**
		 * After adding events from other instances to this instance, all
		 * subscriptions will re removed after dispose.
		 */
		protected function addEventSubscription(instance:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
			checkDispose();
			if (!subscriptions) {
				subscriptions = new Dictionary(true);
			}
			if (!subscriptions[type]) {
				subscriptions[type] = new Dictionary(true);
			}
			if (!subscriptions[type][instance]) {
				subscriptions[type][instance] = [];
			}
			ArrayUtils.pushUnique(subscriptions[type][instance], listener);
			instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		protected function removeEventSubscription(instance:IEventDispatcher, type:String, listener:Function):void {
			if (subscriptions && subscriptions[type] && subscriptions[type][instance]) {
				ArrayUtils.remove(subscriptions[type][instance], listener);
				if (!subscriptions[type][instance].length) {
					delete subscriptions[type][instance];
				}
			}
			instance.removeEventListener(type, listener);
		}

		/**
		 * Over normal adding listener, this method also store data about
		 * added listeners. That data will be used at disposing.
		 * 
		 * WARNING:useWeakReference default value is changed to true 
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
			checkDispose();
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (!listeners) {
				listeners = new Dictionary(true);
			}
			if (!listeners[type]) {
				listeners[type] = [];
			}
			ArrayUtils.pushUnique(listeners[type], listener);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (listeners && listeners[type]) {
				ArrayUtils.remove(listeners[type], listener);
			}
			super.removeEventListener(type, listener, useCapture);
		}

		/**
		 * Usable in handlers of one-time-use events.
		 */
		protected function removeEventSubscriptionByEvent(event:Event, handler:Function):void {
			removeEventSubscription(IEventDispatcher(event.target), event.type, handler);
		}

		/**
		 * Call this at the beggining of public methods when you unsure if instance
		 * was succesfully disposed (and is still called by some other classes).  
		 */
		protected function checkDispose():void {
			if (_isDisposed) {
				throw new IllegalOperationError("Instance used after dispose");
			}
		}

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		/**
		 * Prepare class to remove form memory:
		 *  - dispatching event before dispose
		 *  - setting all variables with Object type to null
		 *  - removing listeners
		 *  - removing subscriptions
		 *  - marking instance as disposed
		 *  
		 * Please override with calling super.dispose() at end.
		 */
		public function dispose():void {
			if (_isDisposed) {
				// multiple disposing of the same instance is ok ;)
				return;
			}

			dispatchEvent(new EventPlus(EventPlus.BEFORE_DISPOSED));

			var i:uint;
			var handler:Function;

			// removing all "dispose children"
			if (disposeChildren) {
				var disposeChild:IDisposable;
				for (i = 0;i < disposeChildren.length;i++) {
					disposeChild = disposeChildren[i];
					disposeChild.removeEventListener(EventPlus.BEFORE_DISPOSED, onDisposeChild_BeforeDisposed)
					if (!disposeChild.isDisposed) {
						disposeChild.dispose();
					}
				}
				disposeChildren = null;
			}

			// removing all listeners
			var typeListeners:Array = [];
			for (var type:String in listeners) {
				typeListeners = listeners[type];
				for (i = 0;i < typeListeners.length;i++) {
					handler = typeListeners[i];
					removeEventListener(type, handler);
				}
				delete listeners[type];
			}

			// removing all subscriptions
			for (var type2:String in subscriptions) {
				for (var instance:*/*IEventDispatcher*/ in subscriptions[type2]) {
					typeListeners = subscriptions[type2][instance];
					for (i = 0;i < typeListeners.length;i++) {
						handler = typeListeners[i];
						instance.removeEventListener(type2, handler);
					}
					delete subscriptions[type2][instance];
				}
				delete subscriptions[type2];
			}

			// setting all public variables with at least Object type to null
			// var variableNames:Array = ClassUtils.getVariableNames(this);
			// for (i = 0;i < variableNames.length;i++) {
			// if (this[variableNames[i]] && this[variableNames[i]] is Object) {
			// this[variableNames[i]] = null;
			// }
			// }

			listeners = null
			subscriptions = null
			if (_dbg) {
				_dbg.dispose()
				_dbg = null
			}
			disposeChildren = null
			_isDisposed = true;
		}

		protected function tryDispose(val:IDisposable):void {
			if (val && !val.isDisposed) val.dispose();
		}

		/**
		 * Usefull when you create instance by dependency injection, and there is
		 * just no place to set the reference* to it. Of course, with this method
		 * you also don't have to care anymore about disposing of that class. 
		 * 
		 *  * in other way - garbage collector will dispose that class
		 */
		public function addDisposeChild(disposeChild:IDisposable):* {
			if (!disposeChild) throw new IllegalOperationError("disposeChild can't be null");
			checkDispose();
			if (!disposeChildren) {
				disposeChildren = [];
			}
			disposeChildren.push(disposeChild);
			disposeChild.addEventListener(EventPlus.BEFORE_DISPOSED, onDisposeChild_BeforeDisposed)
		}

		protected function adc(disposeChild:IDisposable):* {
			addDisposeChild(disposeChild)
			return disposeChild
		}

		private function onDisposeChild_BeforeDisposed(event:EventPlus):void {
			ArrayUtils.remove(disposeChildren, event.target)
			event.target.removeEventListener(EventPlus.BEFORE_DISPOSED, onDisposeChild_BeforeDisposed)
		}

		public function addDisposeChildren(disposeChildren:Array/*of IDisposable*/):void {
			var i:uint;
			var disposeChild:IDisposable;
			for (i = 0;i < disposeChildren.length;i++) {
				disposeChild = disposeChildren[i];
				addDisposeChild(disposeChild);
			}
		}

		protected function redispatch(obj:IEventDispatcher, eventType:String):void {
			addEventSubscription(obj, eventType, onRedispatch)
		}

		private function onRedispatch(event:Event):void {
			var clone:Event = event.clone()
			if (Object(clone).constructor == Object(event).constructor) {
				dispatchEvent(clone)
			} else {
				throw new IllegalOperationError('Redispatch error. Please write "clone" method implementatio for ' + event + ' class, kthx')
			}
		}

		override public function dispatchEvent(event:Event):Boolean {
			if (isDispatchBlocked) return false
			return super.dispatchEvent(event);
		}

		protected function get root():DisplayObject {
			return RootProvider.getRoot()
		}

		protected function get rootMC():MovieClip {
			return MovieClip(RootProvider.getRoot())
		}

		protected function get stage():Stage {
			return StageProvider.getStage()
		}
	}
}
