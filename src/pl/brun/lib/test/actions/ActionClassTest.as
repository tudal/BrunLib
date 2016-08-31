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
package pl.brun.lib.test.actions {
	import pl.brun.lib.debugger.DebugServiceProxy;
	import pl.brun.lib.test.TestBase;

	import flash.display.MovieClip;

	/**
	 * @author Marek Brun
	 */
	public class ActionClassTest extends TestBase {

		private var mc_anim:MovieClip /*13.5,150.6(12,98) 584.95x157.05 frames:555*/;
		private var mc_anim_a:MovieClip /*3.05,37.7(2.9,16.65) 12.65x38.3 frames:1*/;
		private var mc_anim_b:MovieClip /*85,19.2(84.85,-1.85) 12.65x38.3 frames:1*/;
		private var mc_anim_c:MovieClip /*156.95,19.2(156.8,-1.85) 12.65x38.3 frames:1*/;
		private var mc_anim_d:MovieClip /*228.9,19.2(228.75,-1.85) 12.65x38.3 frames:1*/;
		private var mc_anim_e:MovieClip /*267.4,-2.45(267.25,-23.5) 12.65x38.3 frames:1*/;
		private var mc_anim_g:MovieClip /*380.35,0(380.2,-21.05) 12.65x38.3 frames:1*/;
		private var mc_anim_f:MovieClip /*370.4,15(370.25,-6.05) 12.65x38.3 frames:1*/;
		private var a:RollWhellAndAnimAction;
		private var b:RollWhellAndAnimAction;
		private var c:RollWhellAndAnimAction;
		private var d:RollWhellAndAnimAction;
		private var e:RollWhellAndAnimAction;
		private var f:RollWhellAndAnimAction;
		private var g:RollWhellAndAnimAction;

		public function ActionClassTest() {
			var mc:MovieClip = new ActionsClassTestMC();
			holder.addChild(mc);
			
			mc_anim = MovieClip(mc.anim);
			mc_anim_a = MovieClip(mc.anim.a);
			mc_anim_b = MovieClip(mc.anim.b);
			mc_anim_c = MovieClip(mc.anim.c);
			mc_anim_d = MovieClip(mc.anim.d);
			mc_anim_e = MovieClip(mc.anim.e);
			mc_anim_g = MovieClip(mc.anim.g);
			mc_anim_f = MovieClip(mc.anim.f);
			
			mc_anim.gotoAndStop(1);
			
			//aIni0,aIni1,bIni0,bMid,bEnd1,cIni0,cMid,cEnd1,dIni0,dIni1,eIni0,eMid,eEnd1,dEnd0,dEnd1,aEnd0,aEnd1,gIni0,gMid,gEnd1			
			//aIni0,aIni1,aEnd0,aEnd1
			a = new RollWhellAndAnimAction(mc_anim_a, 'A', 'aIni0', 'aIni1', mc_anim, 'aEnd0', 'aEnd1');
			b = new RollWhellAndAnimAction(mc_anim_b, 'B', 'bIni0', 'bMid', mc_anim, 'bMid', 'bEnd1');			DebugServiceProxy.forInstance(b).registerInContex('x');			a.addChildAction(b);
			c = new RollWhellAndAnimAction(mc_anim_c, 'C', 'cIni0', 'cMid', mc_anim, 'cMid', 'cEnd1');
			a.addChildAction(c);
			d = new RollWhellAndAnimAction(mc_anim_d, 'D', 'dIni0', 'dIni1', mc_anim, 'dEnd0', 'dEnd1');
			a.addChildAction(d);
			e = new RollWhellAndAnimAction(mc_anim_e, 'E', 'eIni0', 'eMid', mc_anim, 'eMid', 'eEnd1');
			d.addChildAction(e);
			f = new RollWhellAndAnimAction(mc_anim_f, 'F', 'f', 'f', mc_anim);
			a.addChildAction(f);
			g = new RollWhellAndAnimAction(mc_anim_g, 'G', 'gIni0', 'gMid', mc_anim, 'gMid', 'gEnd1');
			f.addChildAction(g);
		}
	}
}
/*

'aIni0', 'aIni1', 'aEnd0', 'aEnd1'
			
'bIni0', 'bMid', 'bMid', 'bEnd1'

'cIni0', 'cMid', 'cMid', 'cEnd1'

'dIni0', 'dIni1', 'dEnd0', 'dEnd1'

'eIni0', 'eMid', 'eMid', 'eEnd1'

''

'gIni0', 'gMid', 'gMid', 'gEnd1'

*/

