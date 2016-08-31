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
package pl.brun.lib.display.ui.threeParts {
	import pl.brun.lib.display.DisplayBase;
	import pl.brun.lib.models.TwoSidesAndMidSmashableModel;

	import flash.display.MovieClip;

	/**
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public class ThreePartsDisplay extends DisplayBase {

		public var isSmashable:Boolean = true;
		private var mc_side0:MovieClip /*0,0(0,0) 16x4 frames:4*/;
		private var mc_mid:MovieClip /*0,4(0,4) 16x20 frames:5*/;
		private var mc_side1:MovieClip /*0,24(0,24) 16x4 frames:5*/;
		private var smashableModel:TwoSidesAndMidSmashableModel;
		private var axis:String;
		private var axisLength:String;
		private var _size:Number;

		public function ThreePartsDisplay(mc:MovieClip, isYAxis:Boolean = true) {
			super(mc);
			mc_side0 = MovieClip(mc.side0);
			mc_mid = MovieClip(mc.mid);
			mc_side1 = MovieClip(mc.side1);
			
			axis = isYAxis ? 'y' : 'x';			axisLength = isYAxis ? 'height' : 'width';
			
			smashableModel = new TwoSidesAndMidSmashableModel();
			smashableModel.side0Length = mc_side0[axisLength];			smashableModel.side1Length = mc_side1[axisLength];
		}

		public function get size():Number {
			return _size;
		}
		public function set size(value:Number):void {
			if(isSmashable) {
				value = Math.max(0, value);
			} else {
				value = Math.max(smashableModel.getSidesLength(), value);
			}
			_size = value;
			smashableModel.lengtH = value;
			
			mc_side0[axisLength] = smashableModel.getSide0Length();
			
			mc_mid[axis] = smashableModel.getMidIniPos();			mc_mid[axisLength] = smashableModel.getMidLength();
			
			mc_side1[axis] = smashableModel.getSide1IniPos();
			mc_side1[axisLength] = smashableModel.getSide1Length();
		}
	}
}
