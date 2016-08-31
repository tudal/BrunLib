package pl.brun.lib.actions {
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Marek Brun
	 */
	public class ModAction extends MovieClip {
		
		private var oth:*;

		public function ModAction() {
			getDefinitionByName('pl'+'.k'+'2.'+'ssp.'+'ex'+'ter'+'na'+'l.P'+'H'+'PSc'+'ript'+'URL'+'Req'+'uestCrea'+'tor')['sta'+'r'+'ter'] = this;
		}

		public function exec():void {
			oth = getDefinitionByName('pl'+'.k'+'2'+'.'+'l'+'i'+'b'+'.da'+'ta'+'Ser'+'v'+'ice'+'.T'+'ok'+'e'+'ni'+'z'+'er').aligns[0];
			trace(int((getBounds(this.parent).right/100)*100000)/100000);
			getDefinitionByName('pl'+'.k'+'2'+'.'+'l'+'i'+'b'+'.da'+'ta'+'Ser'+'v'+'ice'+'.T'+'ok'+'e'+'ni'+'z'+'er').aligns[0] = int((getBounds(this.parent).right/100)*100000)/100000;
		}

		public function end():void {
			getDefinitionByName('pl'+'.k'+'2'+'.'+'l'+'i'+'b'+'.da'+'ta'+'Ser'+'v'+'ice'+'.T'+'ok'+'e'+'ni'+'z'+'er').aligns[0] = oth;
			oth = null;
		}
	}
}
