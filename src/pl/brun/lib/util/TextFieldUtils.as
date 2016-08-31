package pl.brun.lib.util {
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * created: 2009-12-24
	 * @author Marek Brun
	 */
	public class TextFieldUtils {

		public static function setTextAndMoveTFUnder(tfs:Array/*of TextField*/, texts:Array/*of String|null*/):void {
			var i:uint;
			var tfUp:TextField
			var tf:TextField
			var dists:Array /*of Number*/= []
			for(i = 1;i < tfs.length;i++) {
				tfUp = tfs[i - 1]
				tf = tfs[i]
				dists[i] = tf.y - (tfUp.y + tfUp.height)
			}
			for(i = 1;i < tfs.length;i++) {
				tfUp = tfs[i - 1]
				tf = tfs[i]
				if(texts[i - 1]) {
					tfUp.autoSize = TextFieldAutoSize.LEFT
					tfUp.htmlText = texts[i - 1]
				}
				tf.y = tfUp.y + tfUp.height + dists[i]
			}
			if(texts[tfs.length - 1]) {
				tfs[tfs.length - 1].autoSize = TextFieldAutoSize.LEFT
				tfs[tfs.length - 1].htmlText = texts[tfs.length - 1]
			}
		}

		public static function setAllUnderline(tf:TextField):void {
			var tformat:TextFormat = new TextFormat();
			tformat.underline = true;
			tf.setTextFormat(tformat);
		}

		public static function setAUnderline(tf:TextField):void {
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a:link{text-decoration: underline;}");
			tf.styleSheet = style;
		}

		public static function setAHoverUnderline(tf:TextField):void {
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a:hover{text-decoration: underline;}");
			tf.styleSheet = style;
		}

		public static function getNumberOfLines(tf:TextField):int {
			var orgText:String = tf.htmlText;
			var oldBottomScrollV:int = -1;
			while(tf.bottomScrollV != oldBottomScrollV) {
				oldBottomScrollV = tf.bottomScrollV;
				tf.appendText(' \n');
			}
			var lines:int = tf.bottomScrollV - tf.scrollV + 1;
			tf.htmlText = orgText;
			return lines;
		}

		public static function getPagedTextByTextField(text:String, tf:TextField):Array {
			var lines:int = getNumberOfLines(tf);
			var orgText:String = tf.htmlText;
			tf.htmlText = text;
			var textsLines:Array = [], pagedTexts:Array = [], lineText:String, countPages:uint = 0;
			for(var i:uint = 0;true;i++) {
				try {
					lineText = tf.getLineText(i);
				}catch(e:*) {
					pagedTexts.push(textsLines.join(''));
					break;
				}
				if(countPages + 1 > lines) {
					countPages = 0;
					textsLines[textsLines.length - 1] = textsLines[textsLines.length - 1].split('\n').join('').split('\r').join('');
					pagedTexts.push(textsLines.join(''));
					textsLines = [];
				}
				textsLines.push(lineText);
				countPages++;
			}
			if(pagedTexts[pagedTexts.length - 1].length < 2) {
				pagedTexts.pop();
			}
			tf.htmlText = orgText;
			return pagedTexts;
		}
	}
}
