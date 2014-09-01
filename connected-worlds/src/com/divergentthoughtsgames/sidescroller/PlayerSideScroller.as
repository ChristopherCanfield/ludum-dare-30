package com.divergentthoughtsgames.sidescroller 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBar;
	
	import com.divergentthoughtsgames.assets.Assets;
	
	/**
	 * The player.
	 * @author Christopher D. Canfield
	 */
	public class PlayerSideScroller extends FlxSprite
	{		
		private var startX:int;
		private var startY:int;
		
		private var level:FlxTilemap;
		private var gameState:FlxState;
		
		//private var healthBar:FlxBar;
		
		private var lives:int = 3;
		
		private const cameraTarget:FlxObject = new FlxObject();
		private var minCameraX:int;
		private var maxCameraX:int;
		
		public function PlayerSideScroller(gameState:FlxState, level:FlxTilemap, 
				startX:int, startY:int,
				minCameraX:int, maxCameraX:int) 
		{
			this.startX = startX;
			this.startY = startY;
			
			this.level = level;
			this.gameState = gameState;
			
			this.minCameraX = minCameraX;
			this.maxCameraX = maxCameraX;
			cameraTarget.y = level.height / 2;
			cameraTarget.x = startX;
			
			x = startX;
			y = startY;
			maxVelocity.x = 80;
			maxVelocity.y = 250;
			acceleration.y = 200;
			drag.x = maxVelocity.x * 4;
			
			//makeGraphic(10, 12, 0xffaa1111);
			//var image:FlxSprite = loadGraphic(DUCK, false, true);
			var image:FlxSprite = loadGraphic(Assets.graphics.Chickens, true, true, 12, 14);
			addAnimation("walk", [0, 1, 2], 12, true);
			addAnimation("stop", [0], 0);
			play("stop");
			
			//var image:FlxSprite = loadGraphic(marioWalk, true, false, 16, 28, false);			
			//addAnimation("stop", [0], 0, true);
			//addAnimation("walk", [0, 1, 2], 12, true);
			//play("stop");
			
			//healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, width, 4, this, "health");
			//healthBar.trackParent(0, -5);
			//gameState.add(healthBar);
		}
		
		public function getLives():int
		{
			return lives;
		}
		
		public function getCameraTarget() : FlxObject
		{
			return cameraTarget;
		}
	
		override public function update():void
		{
			if (checkForDeath())
			{
				lives--;
				resetAtStartPosition();
			}
			
			processUserInput();
			moveCamera();
		}
		
		private function processUserInput():void
		{
			acceleration.x = 0;
			
			if ((FlxG.keys.LEFT || FlxG.keys.A) && (x - width > 0))
			{
				// The player reaches its top speed very quickly.
				acceleration.x = -maxVelocity.x * 4;
				facing = FlxObject.LEFT;
			}
			if ((FlxG.keys.RIGHT || FlxG.keys.D) && (x < level.width - width * 4))
			{
				acceleration.x = maxVelocity.x * 4;
				facing = FlxObject.RIGHT;
			}
			
			if ((FlxG.keys.SPACE || FlxG.keys.UP || FlxG.keys.W)
					&& isTouching(FlxObject.FLOOR))
			{
				jump();
			}
			
			animate();
		}
		
		override public function reset(x:Number, y:Number):void
		{
			super.reset(x, y);
			
			this.acceleration.x = 0;
			this.acceleration.y = 200;
		}
		
		/**
		 * Resets the player at the starting position.
		 */
		private function resetAtStartPosition():void
		{
			reset(startX, startY);
		}
		
		private function checkForDeath():Boolean
		{
			return (y > level.height);
		}
		
		private function animate() : void
		{
			if (velocity.x != 0 || velocity.y != 0) 
			{
				play("walk");
			} 
			else 
			{ 
				play("stop");
			}
		}
		
		private function moveCamera() : void
		{
			cameraTarget.x = x;
			if (cameraTarget.x < minCameraX)
			{
				cameraTarget.x = minCameraX;
			}
			else if (cameraTarget.x > maxCameraX)
			{
				cameraTarget.x = maxCameraX;
			}
		}
		
		private function jump() : void
		{
			velocity.y = -maxVelocity.y / 2;
			FlxG.play(Assets.audio.Jump, 0.25);
		}
	}
}