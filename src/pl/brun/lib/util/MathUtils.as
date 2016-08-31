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
	import flash.geom.Point;

	/**
	 * @author Marek Brun
	 */
	public class MathUtils {
		public static const TO_RADIANS:Number = Math.PI / 180;
		public static const TO_ANGLE:Number = 180 / Math.PI;

		public static function getNext(min:Number, max:Number, currentNumber:Number):Number {
			currentNumber++;
			if (currentNumber > max) {
				return min;
			}
			return currentNumber;
		}

		public static function getPrev(min:Number, max:Number, currentNumber:Number):Number {
			currentNumber--;
			if (currentNumber < min) {
				return max;
			}
			return currentNumber;
		}

		public static function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var oxp:Number = x2 - x1;
			var oyp:Number = y2 - y1;
			return Math.sqrt(oxp * oxp + oyp * oyp);
		}

		public static function pointsDist(point0:Point, point1:Point):Number {
			return dist(point0.x, point0.y, point1.y, point1.y);
		}

		public static function getHEXByRGB(r:Number, g:Number, b:Number):Number {
			return r << 16 | g << 8 | b;
		}

		public static function getRGBByHEX(hex:Number):Object {
			return {r:hex >> 16, g:Math.floor(hex / 256) % 256, b:hex % 256};
		}

		public static function getRescaleToRect(toRectWidth:Number, toRectHeight:Number, width:Number, height:Number, isInside:Boolean = true):Number {
			if (isInside) {
				if (toRectWidth / toRectHeight > width / height) {
					return toRectHeight / height;
				} else {
					return toRectWidth / width;
				}
			} else {
				if (width / height > toRectWidth / toRectHeight) {
					return toRectHeight / height;
				} else {
					return toRectWidth / width;
				}
			}
		}

		public static function getXYAlignMidAfterRescaleToRect(toRectWidth:Number, toRectHeight:Number, width:Number, height:Number):Point {
			if (toRectWidth / toRectHeight > width / height) {
				return new Point(toRectWidth / 2 - (width * (toRectHeight / height)) / 2, 0);
			} else {
				return new Point(0, toRectHeight / 2 - (height * (toRectWidth / width)) / 2);
			}
		}

		public static function getAngleByPoints(x0:Number, x1:Number, y0:Number, y1:Number):Number {
			return Math.atan2(y1 - y0, x1 - x0) * (180 / Math.PI);
		}

		public static function getRad(x0:Number, y0:Number, x1:Number, y1:Number):Number {
			return Math.atan2(y1 - y0, x1 - x0);
		}

		public static function getRadByPoints(point1:Point, point2:Point):Number {
			return Math.atan2(point2.y - point1.y, point2.x - point1.x);
		}

		public static function scopeRoll(ini:Number, end:Number, n:Number):Number {
			var dist:Number = end - ini;
			if (n < 0) {
				n += dist * (int((-n) / dist) + 1);
			}

			return ini + dist * ((n % dist) / dist);
		}

		static public function getMirrorSin(num:Number):Number {
			if (num > 0) {
				return 1 - (Math.sin((1 - num) * Math.PI / 2));
			} else {
				return -(1 - (Math.sin((1 - num) * Math.PI / 2)));
			}
		}

		static public function isLinesCross(x11:Number, y11:Number, x12:Number, y12:Number, x21:Number, y21:Number, x22:Number, y22:Number):Boolean {
			var cross:Point = getLinesCrossPoint(x11, y11, x12, y12, x21, y21, x22, y22);
			if ((cross.x >= x11 && cross.x <= x12) || (cross.x <= x11 && cross.x >= x12)) {
				if ((cross.x >= x21 && cross.x <= x22) || (cross.x <= x21 && cross.x >= x22)) {
					return true;
				}
			}
			return false;
		}

		static public function getLinesCrossPoint(x11:Number, y11:Number, x12:Number, y12:Number, x21:Number, y21:Number, x22:Number, y22:Number):Point {
			var va0:Number = x12 * y11 - x11 * y12;
			var a1:Number = (y11 - y12) / va0;
			var b1:Number = (x12 - x11) / va0;
			var va:Number = x22 * y21 - x21 * y22;
			var a2:Number = (y21 - y22) / va;
			var b2:Number = (x22 - x21) / va;
			return new Point((b1 - b2) / (a2 * b1 - a1 * b2), (a1 - a2) / (b2 * a1 - b1 * a2));
		}

		static public function lineIntersectLine(a:Point, b:Point, e:Point, f:Point, as_seg:Boolean = true):Point {
			var ip:Point;
			var a1:Number;
			var a2:Number;
			var b1:Number;
			var b2:Number;
			var c1:Number;
			var c2:Number;

			a1 = b.y - a.y;
			b1 = a.x - b.x;
			c1 = b.x * a.y - a.x * b.y;
			a2 = f.y - e.y;
			b2 = e.x - f.x;
			c2 = f.x * e.y - e.x * f.y;

			var denom:Number = a1 * b2 - a2 * b1;
			if (denom == 0) {
				return null;
			}
			ip = new Point();
			ip.x = (b1 * c2 - b2 * c1) / denom;
			ip.y = (a2 * c1 - a1 * c2) / denom;

			// ---------------------------------------------------
			// Do checks to see if intersection to endpoints
			// distance is longer than actual Segments.
			// Return null if it is with any.
			// ---------------------------------------------------
			if (as_seg) {
				if (Math.pow(ip.x - b.x, 2) + Math.pow(ip.y - b.y, 2) > Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2)) {
					return null;
				}
				if (Math.pow(ip.x - a.x, 2) + Math.pow(ip.y - a.y, 2) > Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2)) {
					return null;
				}

				if (Math.pow(ip.x - f.x, 2) + Math.pow(ip.y - f.y, 2) > Math.pow(e.x - f.x, 2) + Math.pow(e.y - f.y, 2)) {
					return null;
				}
				if (Math.pow(ip.x - e.x, 2) + Math.pow(ip.y - e.y, 2) > Math.pow(e.x - f.x, 2) + Math.pow(e.y - f.y, 2)) {
					return null;
				}
			}
			return ip;
		}
	}
}