package com.divergentthoughtsgames.topdown {
	
	import com.divergentthoughtsgames.assets.Assets;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	
	/**
	 * The player.
	 * @author Christopher D. Canfield
	 */
	public class PlayerTopDown extends FlxSprite
	{		
		public var previousX: Number;
		public var previousY: Number;
		
		private var startX:int;
		private var startY:int;
		
		private var gameState:FlxState;
		
		private var lives:int = 3;
		
		public function PlayerTopDown(gameState:FlxState, startX:int, startY:int) 
		{
			this.startX = startX;
			this.startY = startY;
			
			this.gameState = gameState;
			
			x = startX;
			y = startY;
			maxVelocity.x = maxVelocity.y = 80;
			drag.x = maxVelocity.x * 4;
			drag.y = maxVelocity.y * 4;
			
			var image:FlxSprite = loadGraphic(Assets.graphics.Chickens, true, true, 16, 19);
			addAnimation("walk", [0, 1, 2], 12, true);
			addAnimation("stop", [0], 0);
			play("stop");
		}
			
		public function getLives(): int
		{
			return lives;
		}
		
		public function savePosition(): void
		{
			previousX = x;
			previousY = y;
		}
	
		override public function update():void
		{
			if (checkForDeath())
			{
				lives--;
				resetAtStartPosition();
			}
			
			var minX:Number = 0;
			var minY:Number = 0;
			var maxX:Number = FlxG.worldBounds.width - frameWidth;
			var maxY:Number = FlxG.worldBounds.height - frameHeight;
			
			processUserInput(minX, minY, maxX, maxY);
			stayWithinBounds(minX, minY, maxX, maxY);
		}
		
		private function processUserInput(minX: Number, minY: Number, maxX: Number, maxY: Number): void
		{
			acceleration.x = 0;
			acceleration.y = 0;
			
			var speedModifier: int = (FlxG.keys.SHIFT) ? 8 : 4;
			
			if ((FlxG.keys.LEFT || FlxG.keys.A) && (x > minX))
			{
				// The player reaches its top speed very quickly.
				acceleration.x = -maxVelocity.x * speedModifier;
				facing = FlxObject.LEFT;
			}
			else if ((FlxG.keys.RIGHT || FlxG.keys.D) && (x < maxX))
			{
				acceleration.x = maxVelocity.x * speedModifier;
				facing = FlxObject.RIGHT;
			}
			
			if ((FlxG.keys.UP || FlxG.keys.W) && (y < maxY))
			{
				acceleration.y = -maxVelocity.y * speedModifier;
				facing = FlxObject.UP;
			}
			else if (FlxG.keys.DOWN || FlxG.keys.S && (y > minY))
			{
				acceleration.y = maxVelocity.y * speedModifier;
				facing = FlxObject.DOWN;
			}
			
			// "Use" key.
			if (FlxG.keys.E)
			{
				// TODO: implement "Use".
				//  - Think about what needs to be done...
			}
			
			// Debugging: print the player's location to the console.
			if (FlxG.keys.CONTROL && FlxG.debug)
			{
				trace("X: " + x + "; Y: " + y);
			}
			
			animate();
		}
		
		private function stayWithinBounds(minX: Number, minY: Number, maxX: Number, maxY: Number): void
		{
			if (x > maxX)
			{
				x = maxX - 1;
				acceleration.x = velocity.x = 0;
			}
			else if (x < minX)
			{
				x = minX + 1;
				acceleration.x = velocity.x = 0;
			}
			
			if (y > maxY)
			{
				y = maxY - 1;
				acceleration.y = velocity.y = 0;
			}
			else if (y < minY)
			{
				y = minY + 1;
				acceleration.y = velocity.y = 0;
			}
		}
		
		override public function reset(x: Number, y: Number): void
		{
			super.reset(x, y);
			
			this.acceleration.x = 0;
			this.acceleration.y = 0;
		}
		
		/**
		 * Resets the player at the starting position.
		 */
		private function resetAtStartPosition(): void
		{
			reset(startX, startY);
		}
		
		private function checkForDeath(): Boolean
		{
			return (health <= 0);
		}
		
		private function animate(): void
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
	}
}