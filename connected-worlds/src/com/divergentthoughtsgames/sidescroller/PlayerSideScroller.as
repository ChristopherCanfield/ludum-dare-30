package com.divergentthoughtsgames.sidescroller 
{
	import com.divergentthoughtsgames.gamestate.PlayState;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	
	import com.divergentthoughtsgames.assets.Assets;
	import com.divergentthoughtsgames.util.MathUtils;
	
	/**
	 * The player.
	 * @author Christopher D. Canfield
	 */
	public class Player extends FlxSprite
	{		
		public static const HEIGHT: uint = 207;
		public static const FRAME_WIDTH: uint = 145;
		public static const WIDTH: uint = FRAME_WIDTH - 70;
		public static const BOUNDING_BOX_OFFSET_X: uint = 30;
		
		public static const MIN_SCALE_FACTOR: Number = 0.72;
		
		private var playerNumber: int;
		
		private var startX: int;
		private var startY: int;
		
		// For scaling the player.
		private var floorArea: FlxRect;
		
		// Enables jumping.
		public var jumpFloor: FlxObject;
		// The original top bound (the bound that prevents the player from walking off the
		// top of the floor).
		private var originalTopBound: Number;
		// Whether the player is jumping or not.
		private var isJumping: Boolean = false;
		// The y position at the time of the player's jump.
		private var yAtJump: Number;
		
		private var gameState: PlayState;
		
		private var healthBar:FlxBar;
		
		private var lives:int = 3;
		
		public var particleGroup: FlxGroup = new FlxGroup(200);
		
		private var punch: Attack;
		
		public function Player(gameState: PlayState, attackGroup: FlxGroup, startX: int, startY: int,
				floorArea: FlxRect, playerNumber: int) 
		{
			this.startX = startX;
			this.startY = startY;
			this.floorArea = floorArea;
			
			jumpFloor = new FlxObject(0, -100, floorArea.width, 20);
			jumpFloor.immovable = true;
			gameState.add(jumpFloor);
			
			this.gameState = gameState;
			this.playerNumber = playerNumber;
			
			health = 100;
			
			x = startX;
			y = startY;
			maxVelocity.x = 300;
			maxVelocity.y = 150;
			//acceleration.y = 700;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			
			facing = (playerNumber == 1) ? FlxObject.RIGHT : FlxObject.LEFT;
			
			var image:FlxSprite = loadGraphic(Assets.graphics.StickMan, true, true, FRAME_WIDTH, HEIGHT);
			addAnimation("stop", [0, 1, 2], 8, true);
			addAnimation("run", [3, 4, 5, 6, 7, 8], 14, true);
			addAnimation("punch", [9, 10, 11, 12], 11, false);
			play("stop");
			
			// Adjust bounding box.
			width = WIDTH;
			offset.x = BOUNDING_BOX_OFFSET_X;
			
			// Add health bar.
			healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, width, 4, this, "health");
			healthBar.trackParent(0, -5);
			gameState.add(healthBar);
			
			punch = new Attack(this, attackGroup, "punch");
			punch.minDamage = 5;
			punch.maxDamage = 12;
			punch.projectileHeight = punch.projectileWidth = 3;
			punch.speed = 1000;
			punch.range = 50;
			// Specifies whether a visualization of the attack should be drawn.
			punch.debug = false;
		}
		
		public function getLives():int
		{
			return lives;
		}
	
		override public function update():void
		{
			if (health <= 0)
			{
				//lives--;
				//resetAtStartPosition();
				
				explode();
				healthBar.kill();
				kill();
				return;
			}
			
			health += 0.05;
			processUserInput();
			scalePlayer();
			
			if (isJumping)
			{
				// The jump floor starts too low.
				jumpFloor.y -= 0.45;
			}
		}
		
		private function processUserInput():void
		{
			acceleration.x = 0;
			if (!isJumping) acceleration.y = 0;
			
			if ((FlxG.keys.A && playerNumber == 1) || (FlxG.keys.LEFT && playerNumber == 2))
			{
				acceleration.x = -maxVelocity.x * 8;
				facing = FlxObject.LEFT;
			}
			if ((FlxG.keys.D && playerNumber == 1) || (FlxG.keys.RIGHT && playerNumber == 2))
			{
				acceleration.x = maxVelocity.x * 8;
				facing = FlxObject.RIGHT;
			}
			
			if (((FlxG.keys.SPACE && playerNumber == 1) || (FlxG.keys.SPACE && playerNumber == 2))
					&& !isJumping)
			{
				jump();
			}
			
			if (!isJumping)
			{
				if ((FlxG.keys.W && playerNumber == 1) || (FlxG.keys.UP && playerNumber == 2))
				{
					acceleration.y = -maxVelocity.y * 2;
				}
				if ((FlxG.keys.S && playerNumber == 1) || (FlxG.keys.DOWN && playerNumber == 2))
				{
					acceleration.y = maxVelocity.y * 2;
				}
			}
			
			if ((FlxG.keys.E && playerNumber == 1) || (FlxG.keys.SHIFT && playerNumber == 2))
			{
				attack(punch);
			}
			
			animate();
		}
		
		override public function reset(x:Number, y:Number):void
		{
			super.reset(x, y);
			
			this.acceleration.x = 0;
			this.acceleration.y = 0;
			this.health = 100;
		}
		
		/**
		 * Resets the player at the starting position.
		 */
		private function resetAtStartPosition():void
		{
			reset(startX, startY);
		}
		
		private function animate(): void
		{
			if (_curAnim.name != punch.animationName)
			{
				if (velocity.x != 0 || velocity.y != 0)
				{
					play("run");
				} 
				else 
				{ 
					play("stop");
				}
			}
		}
		
		private function jump(): void
		{
			// Jump.
			velocity.y = -maxVelocity.y * 20;
			isJumping = true;
			
			// Create new floor at the player's feet.
			jumpFloor.y = y + height + 22.5;
			yAtJump = y;
			
			// Remove floor bounds.
			originalTopBound = gameState.floorTop.y;
			gameState.floorTop.y = 0;
			gameState.floorBottom.y = 0;
			
			// Enable gravity.
			acceleration.y = 500;
			
			//FlxG.play(Assets.audio.Jump, 0.25);
		}
		
		public function onJumpComplete(object1: FlxObject, object2: FlxObject): void
		{
			isJumping = false;
			jumpFloor.y = -100;
			y = yAtJump;
			
			gameState.floorTop.y = originalTopBound;
			gameState.floorBottom.y = floorArea.bottom;
			
			acceleration.y = 0;
			velocity.y = 0;
		}
		
		private function attack(attack: Attack): void
		{
			if (attack.ready)
			{
				play(attack.animationName);
				addAnimationCallback(onAttackComplete);
				attack.execute();
				
				var direction: int = (facing == RIGHT) ? 1 : -1;
				acceleration.x = maxVelocity.x * 2 * direction;
			}
		}
		
		/**
		 * 
		 * @param	name
		 * @param	frameNumber the frame number of the animation.
		 * @param	frameIndex the frame number in the entire sprite sheet.
		 */
		private function onAttackComplete(name: String, frameNumber: uint, frameIndex: uint): void
		{
			if (frameNumber == _curAnim.frames.length - 1)
			{
				if (name == punch.animationName)
				{
					punch.ready = true;
				}
				
				play("run");
				addAnimationCallback(null);
			}
		}
		
		private function scalePlayer(): void
		{
			if (!isJumping)
			{
				var scaleFactor: Number = 1 + (y + HEIGHT - floorArea.bottom) / floorArea.bottom;
				
				scale.y = scale.x = scaleFactor;
				width = WIDTH * scaleFactor;
				height = HEIGHT * scaleFactor;
				
				offset.x = (1 - scaleFactor) * 100;
				offset.y = (1 - scaleFactor) * 100;
			}
		}
		
		private function explode(): void
		{
			var emitter: FlxEmitter = new FlxEmitter(x, y);
			var particles:int = 200;
 
			for(var i:int = 0; i < particles; i++)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(5, 5, 0xaa7f0000);
				particle.exists = false;
				emitter.add(particle);
				particleGroup.add(particle);
			}
			
			emitter.gravity = 400;
			emitter.maxParticleSpeed = new FlxPoint(400, 400);
			emitter.bounce = 0.1;
			
			gameState.add(emitter);
			emitter.start(true, 8);
		}
	}
}