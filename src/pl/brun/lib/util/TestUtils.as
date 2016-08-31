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
package pl.brun.lib.util {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * created: 2009-12-20
	 * @author Marek Brun
	 */
	public class TestUtils {
		public static const NAMES:Array = 'Rin Sakura Hina Yua Yuna Miu Yui Aoi Miyu Misaki Hiroto Shota Ren Sota Sora Yuto Yuto Yuma Eita Sho Oliver Jack Harry Charlie Alfie Thomas Joshua William Daniel James'.split(' ')
		public static const LOREM_IPSUM:String = 'on the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. these cases are perfectly simple and easy to distinguish. in a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. but in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted. the wise man therefore always holds in these matters to this principle of selection: he rejects pleasures to secure other greater pleasures, or else he endures pains to avoid worse pains.';
		public static const LOREM_IPSUM_WORDS:Array = LOREM_IPSUM.split(/\W+/);
		private static var namesTmp:Array;

		static public function getRandomTextOld(maxLines:uint = 6, maxLineLength:uint = 40, baseText:String = null):String {
			if (!baseText) {
				baseText = LOREM_IPSUM;
			}
			var cutText:String = baseText;

			var linesCount:uint = getCount(1, maxLines)
			var lines:Array /*of String*/ 
			= [];
			var line:String;
			while (linesCount) {
				linesCount--;
				line = getRandomOneLineText(maxLineLength, cutText);
				lines.push(line);
				if (line.length > cutText.length) {
					cutText = baseText;
				} else {
					cutText = cutText.substr(line.length);
				}
			}
			lines[lines.length - 1] = lines[lines.length - 1] + ' end.';
			return lines.join('\n');
		}

		static public function getRandomOneLineText(maxLength:uint = 40, baseText:String = null):String {
			if (!baseText) {
				baseText = LOREM_IPSUM;
			}
			return baseText.substr(0, int(Math.min(baseText.length, maxLength - 5) * Math.random())) + ' end.';
		}

		static public function getRandomWord():String {
			return ArrayUtils.getRandom(LOREM_IPSUM_WORDS);
		}

		static public function getRandomText(minSentences:uint = 1, maxSentences:uint = 3, minWords:uint = 4, maxWords:uint = 10):String {
			var count:uint = getCount(minSentences, maxSentences)
			var sentences:Array /*of String*/ 
			= []
			while (count--) {
				sentences.push(getRandomSentence(minWords, maxWords))
			}
			return sentences.join(' ')
		}

		static public function getRandomSentence(minWords:uint = 4, maxWords:uint = 10):String {
			var wordsCount:uint = getCount(minWords, maxWords)
			var sentence:Array /*of String*/ 
			= []
			while (wordsCount--) {
				sentence.push(ArrayUtils.getRandom(LOREM_IPSUM_WORDS))
			}
			sentence[0] = String(sentence[0]).substr(0, 1).toUpperCase() + String(sentence[0]).substr(1)
			return sentence.join(' ') + '.'
		}

		// [A-Z].*?\.
		static public function getRandomName():String {
			if (!namesTmp) {
				namesTmp = NAMES.concat()
			}
			if (!namesTmp.length) {
				namesTmp = NAMES.concat()
			}
			return ArrayUtils.removeRandom(namesTmp);
		}

		public static function getRandomWords(min:uint, max:uint):Array/*of String*/
 		{
			var words:Array /*of String*/ 
			= []
			var count:uint = getCount(min, max)
			while (count--) {
				words.push(getRandomWord())
			}
			return words
		}

		private static function getCount(min:uint, max:uint):uint {
			return min + Math.round(Math.random() * (max - min))
		}

		public static function getDatePlus(milliseconds:Number):Date {
			return new Date(new Date().getTime() + milliseconds)
		}

		public static function getUnixTimePlus(milliseconds:Number):Number {
			return Number(getDatePlus(milliseconds).getTime() / 1000)
		}

		public static function markCenter(display:Sprite, color:uint = 0xFF0000, size:Number = 10):void {
			display.graphics.clear()
			display.graphics.lineStyle(1, color)
			display.graphics.moveTo(-size, -size)
			display.graphics.lineTo(size, size)
			display.graphics.lineTo(size, -size)
			display.graphics.lineTo(-size, size)
		}

		public static function markPoint(display:Sprite, x:Number, y:Number, color:uint = 0xFF0000, size:Number = 10, clear:Boolean=true):void {
			if(clear){
				display.graphics.clear()
			}
			display.graphics.lineStyle(1, color)
			display.graphics.moveTo(-size + x, -size + y)
			display.graphics.lineTo(size + x, size + y)
			display.graphics.lineTo(size + x, -size + y)
			display.graphics.lineTo(-size + x, size + y)
		}

		public static function markBounds(display:Sprite, color:uint = 0xFF0000):void {
			var mark:Sprite = new Sprite()
			var gfx:Graphics = mark.graphics
			var bounds:Rectangle = display.getBounds(display)
			gfx.lineStyle(1, color)
			gfx.drawRect(bounds.x, bounds.y, bounds.width, bounds.height)
			gfx.moveTo(bounds.x, bounds.y)
			gfx.lineTo(bounds.right, bounds.bottom)
			gfx.moveTo(bounds.right, bounds.y)
			gfx.lineTo(bounds.left, bounds.bottom)
			var size:int = 10
			gfx.moveTo(-size, -size)
			gfx.lineTo(size, size)
			gfx.lineTo(size, -size)
			gfx.lineTo(-size, size)
			display.addChild(mark)
		}
	}
}
