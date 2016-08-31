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
package pl.brun.lib.display.button.views {
	import pl.brun.lib.util.DisplayUtils;

	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.errors.IllegalOperationError;

	/**
	 * created: 2009-12-23
	 * @author Marek Brun
	 */
	public class ButtonViewFactoryByLabel {

		/**
		 * If in first frame of MCButton clip you set one frame label:
		 *  - bv:ime
		 *  - bv:3f
		 *  - bv:toEnd
		 * then there will be automatically created and added button view
		 * There can be multiple views (frame labels on different layers)
		 * Some of views can not work properly with each other
		 * (for example MCButtonViewIniMidEnd with MCButtonViewPlayToEndAndBack)
		 */
		public static function createViewsByLabels(mc:MovieClip, checkChildren:Boolean = true):Array/*of AbstractButtonView*/ {
			
			var i:uint;
			var loop:FrameLabel;
			var views:Array /*of AbstractButtonView*/= [];
			for(i = 0;i < mc.currentLabels.length;i++) {
				loop = mc.currentLabels[i];
				if(loop.name.indexOf('bv:') == 0) {
					switch(loop.name.split(':')[1]) {
						case 'ime':
							views.push(new IniMidEndButtonView(mc));
							break;
						case '3f':
							views.push(new ThreeFramesButtonView(mc));
							break;
						case 'toEnd':
							views.push(new PlayToEndAndBackButtonView(mc));
							break;
						case 'oo':
							views.push(new OutOverButtonView(mc));
							break;
						case 'v':
							views.push(new VisibleButtonView(mc));
							break;
						default:
							throw new IllegalOperationError("Unsupported button vew tag:" + loop.name)
					}
				}
			}
			if(checkChildren) {
				var children:Array /*of DisplayObject*/ = DisplayUtils.getChildren(mc)
				var child:DisplayObject
				while(children.length) {
					child = children.pop()
					if(child is MovieClip) {
						views = views.concat(createViewsByLabels(MovieClip(child), false))
					}
				}
			}
			return views;
		}
	}
}
