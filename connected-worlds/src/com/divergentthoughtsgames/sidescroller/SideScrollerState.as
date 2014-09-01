package com.divergentthoughtsgames.sidescroller 
{
	import com.bit101.components.InputText;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxState;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxCamera;
	
	import net.pixelpracht.tmx.*;
	
	import com.bit101.utils.MinimalConfigurator;
	import com.bit101.components.Component;
	
	import com.divergentthoughtsgames.assets.Assets;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class SideScrollerState extends FlxState
	{
		// The level's map.
		private var level:FlxTilemap;
		
		// The player.
		private var player:Player;
		
		private var timeRemainingText:FlxText;
		private var livesText:FlxText;
		
		// The number of seconds per level.
		private const LEVEL_TIME:Number = 50;
		private var timeRemaining:Number = LEVEL_TIME;
		
		private var gameOver:Boolean = false;
		
		[Embed(source = '../../../res/map/smb-level-1.tmx', 
				mimeType="application/octet-stream")] 
		private const Level1Xml:Class;
		
		[Embed(source = '../../../res/map/smb-level-1.png')]
		private const Level1Image:Class;
		
		private var debugConfig:MinimalConfigurator;
		
		public function PlayState()
        {
        }
 
        override public function create():void
        {
            FlxG.bgColor = 0xffaaaaaa;
			
			loadMap();
			
			//Create player (a red box)
			var startX:int = FlxG.width / 2 - 5;
			var startY:int = 0;
			var minCameraX:int = startX;
			var maxCameraX:int = level.width - FlxG.width / 2 - 5;
			player = new Player(this, level, startX, startY, minCameraX, maxCameraX);
			FlxG.camera.follow(player.getCameraTarget(), FlxCamera.STYLE_PLATFORMER);
			add(player);
			
			// Add a label for the score.
			timeRemainingText = new FlxText(2, 2, 80);
			timeRemainingText.scrollFactor.x = timeRemainingText.scrollFactor.y = 0;
			timeRemainingText.shadow = 0xff000000;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			add(timeRemainingText);
			
			// Add a label for the lives.
			livesText = new FlxText(FlxG.width - 45, 2, 45);
			livesText.scrollFactor.x = livesText.scrollFactor.y = 0;
			livesText.shadow = 0xff000000;
			add(livesText);
			
			// Add a play instructions.
			var instructionsText:FlxText = new FlxText(FlxG.width / 2 - 50, 25, 100);
			instructionsText.text = "WASD or Arrow Keys to move";
			instructionsText.shadow = 0xff000000;
			add(instructionsText);
			
			FlxG.playMusic(Assets.audio.MusicTrack1, 0.8);
			
			var variableEditorWindow:VariableEditorWindow = new VariableEditorWindow();
			debugConfig = variableEditorWindow.create(player);
        }
		
		private function loadMap() : void 
		{
			var xml:XML = new XML(new Level1Xml());
			var tmx:TmxMap = new TmxMap(xml);
			
			var mapCsv:String = tmx.getLayer('level').toCsv(tmx.getTileSet('mario-tiles'));
			level = new FlxTilemap();
			level.loadMap(mapCsv, Level1Image, 16, 16, FlxTilemap.OFF, 0, 0, 26);
			add(level);
			
			FlxG.worldBounds.width = level.width;
		}
		
		override public function update(): void
		{
			if (gameOver)
			{
				return;
			}
			
			player.update();
			
			timeRemaining -= FlxG.elapsed;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			gameOver = ((timeRemaining <= 0) ? true : 
					(player.getLives() == 0) ? true : false);
			if (gameOver)
			{
				onGameOver();
			}
			
			livesText.text = "Lives: " + player.getLives();
			
			super.update();
			
			// Process collisions between the level and the player.
			FlxG.collide(level, player);
		}
		
		private function onGameOver() : void
		{
			FlxG.mouse.show();
            FlxG.switchState(new LoseMenuState());
		}
	}
}