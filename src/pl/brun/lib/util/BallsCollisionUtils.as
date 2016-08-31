package pl.brun.lib.util {
	/**
	 * @author Marek Brun
	 */
	public class BallsCollisionUtils {

		public static function linesCross(x11:Number, y11:Number, x12:Number, y12:Number, x21:Number, y21:Number, x22:Number, y22:Number):Object {
			var va0:Number = x12 * y11 - x11 * y12;
			var a1:Number = (y11 - y12) / va0;
			var b1:Number = (x12 - x11) / va0;
			var va:Number = x22 * y21 - x21 * y22;
			var a2:Number = (y21 - y22) / va;
			var b2:Number = (x22 - x21) / va;
			return {x:(b1 - b2) / (a2 * b1 - a1 * b2), y:(a1 - a2) / (b2 * a1 - b1 * a2)};
		}

		public static function distt(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var oxp:Number = x2 - x1;
			var oyp:Number = y2 - y1;
			return Math.sqrt(oxp * oxp + oyp * oyp);
		}
		
		/**
		 * User getAB to create "AB" objects
		 * @return Array [hit xy of ball 0, hit xy of ball 1] 
		 */
		public static function getRealTimeBallsColl(ball0AB:Object, ball1AB:Object, diameter:Number):Array {
			var x0:Number = ball0AB.x0, y0:Number = ball0AB.y0, x1:Number = ball1AB.x0, y1:Number = ball1AB.y0, dist:Number;
			var abF:Object = ball0AB, abS:Object = ball1AB;
			if (ball1AB.dist > abF.dist) {
				abF = ball1AB;
				abS = ball0AB;
			}
			var plusDist01:Number = abF.dist / (diameter / 200);
			var pl:Object = {};
			var p:uint = 0
			pl.x0 = (ball0AB.dist / plusDist01) * Math.cos(ball0AB.rad);
			pl.y0 = (ball0AB.dist / plusDist01) * Math.sin(ball0AB.rad);
			pl.x1 = (ball1AB.dist / plusDist01) * Math.cos(ball1AB.rad);
			pl.y1 = (ball1AB.dist / plusDist01) * Math.sin(ball1AB.rad);
			while (true) {
				x0 += pl.x0;
				y0 += pl.y0;
				x1 += pl.x1;
				y1 += pl.y1;
				dist = distt(x0, y0, x1, y1);
				if (Math.abs(dist - diameter) < 1) {
					return getBallsCollMid(x0, y0, x1, y1, diameter);
				}
				p++;
				if (p > 1000) break;
			}
			return null;
		}

		public static function getBallsCollMid(x0:Number, y0:Number, x1:Number, y1:Number, wid:Number):Array {
			var abBam:Object = getAB(x0, y0, x1, y1, true);
			var xSro:Number = (x0 + x1) / 2;
			var ySro:Number = (y0 + y1) / 2;
			wid = wid / 2 + .5;
			x0 = xSro - wid * abBam.vx;
			y0 = ySro - wid * abBam.vy;
			x1 = xSro + wid * abBam.vx;
			y1 = ySro + wid * abBam.vy;
			return [{x:x0, y:y0}, {x:x1, y:y1}];
		}

		public static function getAB(x0:Number, y0:Number, x1:Number, y1:Number, isSinCos:Boolean):Object {
			var ab:Object = {x0:x0, y0:y0, x1:x1, y1:y1};
			ab.svx = x1 - x0;
			ab.svy = y1 - y0;
			ab.dist = Math.sqrt(ab.svx * ab.svx + ab.svy * ab.svy);
			ab.rad = Math.atan2(ab.svy, ab.svx);
			if (isSinCos) {
				ab.vx = Math.cos(ab.rad);
				ab.vy = Math.sin(ab.rad);
			}
			return ab;
		}
	}
}
