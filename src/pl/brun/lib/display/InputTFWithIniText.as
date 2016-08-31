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
package pl.brun.lib.display {
	import pl.brun.lib.Base;
	import pl.brun.lib.events.EventPlus;
	import pl.brun.lib.service.KeyboardService;
	import pl.brun.lib.util.KeyCode;

	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	[Event(name="submit", type="pl.brun.lib.events.EventPlus")]

	/**
	 * @author Marek Brun
	 */
	public class InputTFWithIniText extends Base {

		public const event_Submit:String = 'Submit';

		public var inputType:Object;		static public const INPUT_TYPE_TEXT:uint = 1;		static public const INPUT_TYPE_MAIL:uint = 2;		static public const INPUT_TYPE_NUMBER:uint = 3;		static public const INPUT_TYPE_PHONE_NUMBER:uint = 4;		static public const INPUT_TYPE_PASSWORD:uint = 5;

		public var tf:TextField;
		public var minChars:Number = 1;
		private var iniText:String;
		private var ks:KeyboardService;
		private var gotFocus:Boolean;
		private var tfRestritOrg:String;

		public function InputTFWithIniText(tf:TextField, InputTFWithIniText_INPUT_TYPE:uint, iniText:String = null) {
			this.tf = tf;
			if(tf.restrict) {
				tfRestritOrg = tf.restrict;
			}
			this.iniText = iniText ? iniText : tf.htmlText;
			tf.htmlText = this.iniText;
			this.iniText = tf.htmlText;
			tf.type = TextFieldType.INPUT;
			tf.selectable = true;
			tf.addEventListener(FocusEvent.FOCUS_IN, onTextField_FocusIn, false, 0, true);
			tf.addEventListener(FocusEvent.FOCUS_OUT, onTextField_FocusOut, false, 0, true);
			tf.addEventListener(TextEvent.TEXT_INPUT, onTextField_TextInput, false, 0, true);
			inputType = InputTFWithIniText_INPUT_TYPE;
			restrict(tf, InputTFWithIniText_INPUT_TYPE);
			ks = KeyboardService.getInstance();
		}

		public function restrict(tf:TextField, InputTFWithIniText_INPUT_TYPE:uint):void {
			if(tfRestritOrg) {
				tf.restrict = tfRestritOrg;
				return;
			}
			switch(InputTFWithIniText_INPUT_TYPE) {
				case INPUT_TYPE_TEXT:
					tf.restrict = null;
					break;
				case INPUT_TYPE_PASSWORD:
					tf.restrict = null;
					break;
				case INPUT_TYPE_MAIL:
					tf.restrict = 'A-Za-z0-9@._\\-';
					break;
				case INPUT_TYPE_PHONE_NUMBER:
					tf.restrict = '0-9\\- +';
					break;
				case INPUT_TYPE_NUMBER:
					tf.restrict = '0-9 ,.';
					break;
			}
		}

		public function getGotText():Boolean {
			if(gotFocus && tf.text == '') {
				return false;
			} else {
				if(tf.text.length<minChars){
					return false;
				}
				
				return tf.htmlText != iniText;
			}
		}

		public function getIsMail():Boolean {
			var text:String = tf.text;
			var okChars:String = "1234567890-_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.@";
			var count:int = 0;
			while(count < text.length) {
				if (okChars.indexOf(text.substr(count, 1)) == -1) {
					return false;
				}
				count++;
			}
			if((text.indexOf("@") > 0) && (text.indexOf("@") == text.lastIndexOf("@"))) {
				if(((text.lastIndexOf(".") > text.indexOf("@")) && (text.lastIndexOf(".") < (text.length - 1))) && ((text.lastIndexOf(".") - text.indexOf("@")) > 1)) {
					return true;
				}
			}
			return false;
		}

		public function setIniText():void {
			tf.htmlText = iniText;
			tf.displayAsPassword = false;
		}

		public function setIsRedBorder(bool:Boolean):void {
			if(bool) {
				tf.border = true;				tf.borderColor = 0xFF0000;
			} else {
				tf.border = false;
			}
		}

		public function getText():String {
			if(tf.htmlText == iniText) {
				return '';
			}
			return tf.text;
		}

		public function setText(text:String):void {
			refreshNumberRestrict();
			tf.text = text;
		}

		public function isValid():Boolean {
			if(getGotText()) {
				if(getText().length < minChars) { 
					return false; 
				}
				switch(inputType) {
					case INPUT_TYPE_MAIL:
						return getIsMail();
						break;
					default: 
						return true;
				}
			} else {
				return false;
			}
		}

		public function chceckIsValidAndSetRedBorder():Boolean {
			var valid:Boolean = isValid();
			setIsRedBorder(!valid);
			return valid;
		}

		private function refreshNumberRestrict():void {
			if(tfRestritOrg) {
				tf.restrict = tfRestritOrg;
			}
			if(inputType == INPUT_TYPE_NUMBER) {
				if(getText().indexOf('.') != -1 || getText().indexOf(',') != -1) {
					tf.restrict = '0-9';
				} else {
					tf.restrict = '0-9,.';
				}
			}else if(inputType == INPUT_TYPE_PASSWORD) {
				tf.displayAsPassword = true;
			}
		}

		//------------------------------------------------------------------------------
		//		events
		//------------------------------------------------------------------------------
		private function onTextField_FocusIn(event:FocusEvent):void {
			gotFocus = true;
			ks.addEventListener(KeyboardEvent.KEY_DOWN, onKS_KeyDown_WhileFocus);
			if(tf.htmlText == iniText) {
				tf.text = '';
			}
		}

		private function onKS_KeyDown_WhileFocus(event:KeyboardEvent):void {
			if(event.keyCode == KeyCode.ENTER) {
				dispatchEvent(new EventPlus(EventPlus.SUBMIT));
			}
		}

		private function onTextField_FocusOut(event:FocusEvent):void {
			gotFocus = false;
			ks.removeEventListener(KeyboardEvent.KEY_DOWN, onKS_KeyDown_WhileFocus);
			if(tf.text == '') {
				setIniText();
			}
		}

		private function onTextField_TextInput(event:TextEvent):void {
			refreshNumberRestrict();
		}
	}
}