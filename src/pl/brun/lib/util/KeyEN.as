package pl.brun.lib.util {
	import flash.utils.Dictionary;

	/**
	 * created: 2010-01-12
	 * @author Marek Brun
	 */
	public class KeyEN {

		private static var dictKeyCode_KeyName:Dictionary;

		public static function getKeyName(keyCode:uint):String {
			return getENKeysDictionary()[keyCode];
		}

		public static function getENKeysDictionary():Dictionary {
			if(!dictKeyCode_KeyName) {
				dictKeyCode_KeyName = new Dictionary();
				dictKeyCode_KeyName[8] = 'BACK';
				dictKeyCode_KeyName[9] = 'TAB';
				dictKeyCode_KeyName[32] = 'SPACE';
				dictKeyCode_KeyName[37] = 'LEFT';
				dictKeyCode_KeyName[39] = 'RIGHT';
				dictKeyCode_KeyName[38] = 'UP';
				dictKeyCode_KeyName[40] = 'DOWN';
				dictKeyCode_KeyName[13] = 'ENTER';
				dictKeyCode_KeyName[17] = 'CTRL';
				dictKeyCode_KeyName[16] = 'SHIFT';
				dictKeyCode_KeyName[27] = 'ESC';
				dictKeyCode_KeyName[65] = 'A';
				dictKeyCode_KeyName[66] = 'B';
				dictKeyCode_KeyName[67] = 'C';
				dictKeyCode_KeyName[68] = 'D';
				dictKeyCode_KeyName[69] = 'E';
				dictKeyCode_KeyName[70] = 'F';
				dictKeyCode_KeyName[71] = 'G';
				dictKeyCode_KeyName[72] = 'H';
				dictKeyCode_KeyName[73] = 'I';
				dictKeyCode_KeyName[74] = 'J';
				dictKeyCode_KeyName[75] = 'K';
				dictKeyCode_KeyName[76] = 'L';
				dictKeyCode_KeyName[77] = 'M';
				dictKeyCode_KeyName[78] = 'N';
				dictKeyCode_KeyName[79] = 'O';
				dictKeyCode_KeyName[80] = 'P';
				dictKeyCode_KeyName[81] = 'Q';
				dictKeyCode_KeyName[82] = 'R';
				dictKeyCode_KeyName[83] = 'S';
				dictKeyCode_KeyName[84] = 'T';
				dictKeyCode_KeyName[85] = 'U';
				dictKeyCode_KeyName[86] = 'V';
				dictKeyCode_KeyName[87] = 'W';
				dictKeyCode_KeyName[88] = 'X';
				dictKeyCode_KeyName[89] = 'Y';
				dictKeyCode_KeyName[90] = 'Z';
				dictKeyCode_KeyName[48] = 'n0';
				dictKeyCode_KeyName[192] = 'TILDE';
				dictKeyCode_KeyName[49] = 'n1';
				dictKeyCode_KeyName[50] = 'n2';
				dictKeyCode_KeyName[51] = 'n3';
				dictKeyCode_KeyName[52] = 'n4';
				dictKeyCode_KeyName[53] = 'n5';
				dictKeyCode_KeyName[54] = 'n6';
				dictKeyCode_KeyName[55] = 'n7';
				dictKeyCode_KeyName[56] = 'n8';
				dictKeyCode_KeyName[57] = 'n9';
				dictKeyCode_KeyName[188] = 'COMMA';
				dictKeyCode_KeyName[190] = 'DOT';
				dictKeyCode_KeyName[112] = 'F1';
				dictKeyCode_KeyName[113] = 'F2';
				dictKeyCode_KeyName[114] = 'F3';
				dictKeyCode_KeyName[115] = 'F4';
				dictKeyCode_KeyName[116] = 'F5';
				dictKeyCode_KeyName[117] = 'F6';
				dictKeyCode_KeyName[118] = 'F7';
				dictKeyCode_KeyName[119] = 'F8';
				dictKeyCode_KeyName[120] = 'F9';
				dictKeyCode_KeyName[19] = 'PAUSE';
				dictKeyCode_KeyName[96] = 'NUM_0';
				dictKeyCode_KeyName[97] = 'NUM_1';
				dictKeyCode_KeyName[98] = 'NUM_2';
				dictKeyCode_KeyName[99] = 'NUM_3';
				dictKeyCode_KeyName[100] = 'NUM_4';
				dictKeyCode_KeyName[101] = 'NUM_5';
				dictKeyCode_KeyName[102] = 'NUM_6';
				dictKeyCode_KeyName[103] = 'NUM_7';
				dictKeyCode_KeyName[104] = 'NUM_8';
				dictKeyCode_KeyName[105] = 'NUM_9';
				dictKeyCode_KeyName[17] = 'ALT';
			}
			return dictKeyCode_KeyName;
		}
	}
}
