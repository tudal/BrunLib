package pl.brun.lib.animation {
	import flash.events.Event;

	import pl.brun.lib.actions.Action;
	import pl.brun.lib.actions.ActionEvent;
	import pl.brun.lib.actions.tools.AnyActionIsRunning;
	import pl.brun.lib.animation.dynamic_.AnimatedInertialNumber;
	import pl.brun.lib.animation.dynamic_.AnimatedStoppingNumber;
	import pl.brun.lib.animation.static_.Animation;
	import pl.brun.lib.managers.OnEventDisposer;
	import pl.brun.lib.models.easing.Easing;
	import pl.brun.lib.models.easing.SinEasing;

	/**
	 * created: 2010-01-24
	 * @author Marek Brun
	 */
	public class Tween {
		private static var defaultEasing:SinEasing;

		/**
		 * @param objectsAndProperties - Array of Array ([[object, param, target value], ...], [[myMc, 'x', 300], [myMc, 'y', 100]])
		 * @param friction - from 0 to 1, bigger - faster
		 * @param acceleration - sets the minimal distance from current to target to set finish
		 */
		public static function tweenStoppingTo(objectsAndProperties:Array/*of Array*/, finishHandler:Function = null, speed:Number = .5, minDistToTarget:Number = 0.01):void {
			var anim:AnimatedStoppingNumber;
			var anims:Array /*of AnimatedInertialNumber*/ 
			= [];
			var i:uint;
			var objNprop:Array/*of **/;
			for(i = 0;i < objectsAndProperties.length;i++) {
				objNprop = objectsAndProperties[i];
				anim = new AnimatedStoppingNumber();
				anim.isAutoStart = false;
				anim.speed = speed;
				anim.minDistToTarget = minDistToTarget;
				anim.target = objNprop[2];
				anim.addAutoMapping(objNprop[0], objNprop[1]);
				anims.push(anim);
			}
			if(finishHandler != null) {
				startAnimsWithHandler(anims, finishHandler);
			} else {
				startAnims(anims);
			}
		}

		/**
		 * @param objectsAndProperties - Array of Array ([[object, param, target value], ...], [[myMc, 'x', 300], [myMc, 'y', 100]])
		 * @param friction - from 0 to 1, smaller - longer animatio		 * @param acceleration - from 0 to 1 (can be unstable if >1), biger - faster
		 */
		public static function tweenInertialTo(objectsAndProperties:Array/*of Array*/, finishHandler:Function = null, friction:Number = .4, acceleration:Number = .5):void {
			var anim:AnimatedInertialNumber;
			var anims:Array /*of AnimatedInertialNumber*/ 
			= [];
			var i:uint;
			var objNprop:Array/*of **/;
			for(i = 0;i < objectsAndProperties.length;i++) {
				objNprop = objectsAndProperties[i];
				anim = new AnimatedInertialNumber();
				anim.isAutoStart = false;
				anim.friction = friction;
				anim.acceleration = acceleration;
				anim.target = objNprop[2];
				anim.addAutoMapping(objNprop[0], objNprop[1]);
				anims.push(anim);
			}
			if(finishHandler != null) {
				startAnimsWithHandler(anims, finishHandler);
			} else {
				startAnims(anims);
			}
		}

		/**
		 * @param objectsAndProperties - Array of Array ([[object, param, target value], ...], [[myMc, 'x', 300], [myMc, 'y', 100]])
		 */
		public static function tweenTo(objectsAndProperties:Array/*of Array*/, time:uint, easing:Easing = null, finishHandler:Function = null, changeHandler:Function = null, start:Boolean = true):Animation {
			if(!easing) {
				if(!defaultEasing) {
					defaultEasing = new SinEasing();
				}
				easing = defaultEasing;
			}
			var anim:Animation = new Animation(time);
			var i:uint;
			var objNprop:Array/*of **/;
			for(i = 0;i < objectsAndProperties.length;i++) {
				objNprop = objectsAndProperties[i];
				anim.addProperty(objNprop[0], objNprop[1], objNprop[2], easing);
			}
			if(finishHandler != null) {
				anim.addEventListener(ActionEvent.RUNNING_FINISH, finishHandler);
			}
			if(changeHandler != null) {
				anim.addEventListener(Event.CHANGE, changeHandler);
			}
			OnEventDisposer.addObjectToDispose(ActionEvent.RUNNING_FINISH, anim);

			if(start) {
				anim.start();
			}

			return anim
		}

		private static function startAnims(anims:Array/*of Action*/):void {
			var i:uint;
			var anim:Action;
			for(i = 0;i < anims.length;i++) {
				anim = anims[i];
				OnEventDisposer.addObjectToDispose(ActionEvent.RUNNING_FINISH, anim);
				anim.start();
			}
		}

		private static function startAnimsWithHandler(anims:Array/*of Action*/, finishHandler:Function):void {
			var anyIsRunning:AnyActionIsRunning = new AnyActionIsRunning();
			anyIsRunning.addEventListener(ActionEvent.RUNNING_FINISH, finishHandler);
			var i:uint;
			var anim:Action;
			for(i = 0;i < anims.length;i++) {
				anim = anims[i];
				anyIsRunning.addActionToObserve(anim);
				anyIsRunning.addDisposeChild(anim);
			}
			for(i = 0;i < anims.length;i++) {
				anim = anims[i];
				anim.start();
			}
			OnEventDisposer.addObjectToDispose(ActionEvent.RUNNING_FINISH, anyIsRunning);
		}
	}
}
