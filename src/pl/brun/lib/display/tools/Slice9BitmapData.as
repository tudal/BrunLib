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
package pl.brun.lib.display.tools {
	import pl.brun.lib.Base;
	import pl.brun.lib.models.TwoSidesAndMidSmashableModel;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Marek Brun
	 */
	public class Slice9BitmapData extends Base {

		public var smoothing:Boolean;
		private var slice9Bitmaps:Array;
		private var data:Scale9VO;
		private var baseWidths:Array;
		private var baseHeights:Array;
		private var baseWidth:int;		private var baseHeight:int;		private static const matrix:Matrix = new Matrix();		private static const rect:Rectangle = new Rectangle();		private static const point:Point = new Point();
		private var tsmY:TwoSidesAndMidSmashableModel;
		private var tsmX:TwoSidesAndMidSmashableModel;
		private var transformedBitmapToPaste:BitmapData;

		public function Slice9BitmapData(baseBD:BitmapData, scale9:Scale9VO = null) {
			//var scaledBD:BitmapData=new BitmapData(width, height, true, 0x00FF00);
			data = scale9 ? scale9 : new Scale9VO();
			
			transformedBitmapToPaste = new BitmapData(2800, 2800, true, 0x00000000);
			
			tsmX = new TwoSidesAndMidSmashableModel();
			tsmY = new TwoSidesAndMidSmashableModel();
			
			baseWidth = baseBD.width;			baseHeight = baseBD.height;
			
			//cutting bitmap for 9 base bitmaps 
			baseWidths = [baseBD.width * this.data.left, //left				baseBD.width - baseBD.width * (this.data.left + 1 - this.data.right), //mid
				baseBD.width * (1 - this.data.right)//right
			];
			baseHeights = [baseBD.height * this.data.top, //up
				baseBD.height - baseBD.height * (this.data.top + 1 - this.data.bottom), //mid
				baseBD.height * (1 - this.data.bottom)//down
			];
			var xs:Array = [0, baseWidths[0], baseWidths[0] + baseWidths[1]];
			var ys:Array = [0, baseHeights[0], baseHeights[0] + baseHeights[1]];
			
			
			slice9Bitmaps = [[], [], []];
			
			var ix:uint, iy:uint, fragmentBD:BitmapData;
			for(ix = 0;ix < 3;ix++) {
				for(iy = 0;iy < 3;iy++) {
					fragmentBD = new BitmapData(baseWidths[ix], baseHeights[iy], true, 0x00000000);
					rect.x = xs[ix];
					rect.y = ys[iy];
					rect.width = baseWidths[ix];
					rect.height = baseHeights[iy];
					point.x=0;
					point.y=0;
					fragmentBD.copyPixels(baseBD, rect, point);
					slice9Bitmaps[ix][iy] = fragmentBD;
				}
			}
		}

		public function getMinWidthWithoutSmashing():Number {
			return baseWidths[0] + baseWidths[2]; 
		}

		public function getMinHeightWithoutSmashing():Number {
			return baseHeights[0] + baseHeights[2];
		}

		public function getScaled9BitmapData(width:Number, height:Number):BitmapData {
			if(width < 1) { 
				width = 1; 
			}
			if(height < 1) { 
				height = 1; 
			}
			var scaledBD:BitmapData = new BitmapData(width, height, true, 0x00000000);
			
			tsmX.side0Length = baseWidths[0];
			tsmX.side1Length = baseWidths[2];
			tsmX.lengtH = width;
			
			tsmY.side0Length = baseHeights[0];
			tsmY.side1Length = baseHeights[2];
			tsmY.lengtH = height;
			
			//var matrix:Matrix = new Matrix();
			matrix.identity();
			matrix.a = width / baseWidth;
			matrix.d = height / baseHeight;
			//matrix.scale(width / baseWidth, height / baseHeight);
			
			//left up
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[0][0], 0, 0, tsmX.getSide0Length(), tsmY.getSide0Length());
			//mid up			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[1][0], tsmX.getMidIniPos(), 0, tsmX.getMidLength(), tsmY.getSide0Length());
			//right up			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[2][0], tsmX.getSide1IniPos(), 0, tsmX.getSide1Length(), tsmY.getSide0Length());
			
			//left mid
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[0][1], 0, tsmY.getMidIniPos(), tsmX.getSide0Length(), tsmY.getMidLength());
			//mid mid
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[1][1], tsmX.getMidIniPos(), tsmY.getMidIniPos(), tsmX.getMidLength(), tsmY.getMidLength());
			//right mid
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[2][1], tsmX.getSide1IniPos(), tsmY.getMidIniPos(), tsmX.getSide1Length(), tsmY.getMidLength());
			
			//left down
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[0][2], 0, tsmY.getSide1IniPos(), tsmX.getSide0Length(), tsmY.getSide1Length());
			//mid down
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[1][2], tsmX.getMidIniPos(), tsmY.getSide1IniPos(), tsmX.getMidLength(), tsmY.getSide1Length());
			//right down
			mergeBitmapWithExactFit(scaledBD, slice9Bitmaps[2][2], tsmX.getSide1IniPos(), tsmY.getSide1IniPos(), tsmX.getSide1Length(), tsmY.getSide1Length());
			
			return scaledBD;
		}

		protected function mergeBitmapWithExactFit(bitmapPasteIn:BitmapData, bitmapToPaste:BitmapData, x:Number, y:Number, width:Number, height:Number):void {
			height = Math.round(height);
			width = Math.round(width);
			if(!width || !height) { 
				return; 
			}
			
			matrix.identity();
			matrix.a = width / bitmapToPaste.width;
			matrix.d = height / bitmapToPaste.height;
			//var transformedBitmapToPaste:BitmapData = new BitmapData(width, height, true, 0x00000000);
			rect.x = 0;
			rect.y = 0;
			rect.width = width;
			rect.height = height;
			transformedBitmapToPaste.fillRect(rect, 0x00000000);
			transformedBitmapToPaste.draw(bitmapToPaste, matrix, null, null, rect, smoothing);
			
			point.x=Math.round(x);			point.y=Math.round(y);
			bitmapPasteIn.merge(transformedBitmapToPaste, rect, point, 0xFF, 0xFF, 0xFF, 0xFF);
			
			//transformedBitmapToPaste.dispose();
		}

		public function getBaseWidth():Number {
			return baseWidth;
		}

		public function getBaseHeight():Number {
			return baseHeight;
		}

		override public function dispose():void {
			var ix:uint, iy:uint;
			for(ix = 0;ix < 3;ix++) {
				for(iy = 0;iy < 3;iy++) {
					BitmapData(slice9Bitmaps[ix][iy]).dispose();
				}
			}
			super.dispose();
		}

		public static function createFromSlicedMC(mc:MovieClip):Slice9BitmapData {
			var bodyBD:BitmapData = new BitmapData(mc.width, mc.height, true, 0x00000000);
			bodyBD.draw(mc);
			
			var scale9:Scale9VO = new Scale9VO(mc.scale9Grid.x / mc.width, (mc.scale9Grid.x + mc.scale9Grid.width) / mc.width, mc.scale9Grid.y / mc.height, (mc.scale9Grid.y + mc.scale9Grid.height) / mc.height);
			
			return new Slice9BitmapData(bodyBD, scale9);
		}
	}
}

class Scale9VO {

	public var left:Number;		
	public var right:Number;		
	public var top:Number;		
	public var bottom:Number;		

	/**
	 * @param xLeft precentage position, from 0 to 1, of left slice 
	 * @param xRight precentage position, from 0 to 1, of right slice 
	 * @param yUp precentage position, from 0 to 1, of up slice 
	 * @param yDown precentage position, from 0 to 1, of down slice 
	 */
	public function Scale9VO(xLeft:Number = .2, xRight:Number = .8, yUp:Number = .2, yDown:Number = .8) {
		this.left = xLeft;
		this.right = xRight;
		this.top = yUp;
		this.bottom = yDown;
	}
}
