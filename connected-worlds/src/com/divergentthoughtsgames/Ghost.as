package com.divergentthoughtsgames {
	
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.plugin.photonstorm.FlxDelay;
	
	import com.divergentthoughtsgames.assets.Assets;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Ghost extends FlxSprite
	{
		private const MOVE_SPEED: Number = 55;
		private const MOVE_SPEED_RANGE: Number = 15;
		
		private const MAX_PATH_TIME: Number = 7000;
		private var timer: FlxDelay;
		
		private var gameState: FlxState;
		private var level: FlxTilemap;
		
		private var target: FlxObject;
		
		public function Ghost(gameState: FlxState, level: FlxTilemap, startX: int, startY: int, target: FlxObject) 
		{
			x = startX;
			y = startY;
			immovable = true;
			
			this.gameState = gameState;
			this.level = level;
			this.target = target;
			
			var image:FlxSprite = loadGraphic(Assets.graphics.Ghost, true, true, 14, 14);
			addAnimation("walk", [0, 1], 12, true);
			play("walk");
			
			timer = new FlxDelay(MAX_PATH_TIME);
			timer.callback = function(): void {
				setNewPath();
			};
		}
		
		override public function update(): void
		{
			super.update();
			
			if (pathSpeed == 0)
			{
				setNewPath();
			}
		}
		
		private function setNewPath(): void
		{
			
			stopFollowingPath(true);
			
			var startPoint: FlxPoint = new FlxPoint(x, y);
			var endPoint: FlxPoint = new FlxPoint(target.x, target.y);
			var path: FlxPath = level.findPath(startPoint, endPoint, true, true);
			if (path != null)
			{
				followPath(path, MOVE_SPEED + (MOVE_SPEED_RANGE * Math.random()));
				timer.reset(MAX_PATH_TIME * Math.random());
			}
			else 
			{
				timer.reset(250);
			}
			
			timer.start();
		}
	}

}