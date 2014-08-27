package com.divergentthoughtsgames.sidescroller {
	
	import exalted.input.XboxController;
	import exalted.input.XboxInput;
	import flash.geom.Rectangle;
	import org.flixel.FlxRect;
	import org.flixel.plugin.photonstorm.FlxCollision;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxCamera;
	
	import net.pixelpracht.tmx.*;
	
	import com.bit101.components.InputText;
	import com.bit101.utils.MinimalConfigurator;
	import com.bit101.components.Component;
	
	import com.divergentthoughtsgames.*;
	import com.divergentthoughtsgames.assets.*;
	import com.divergentthoughtsgames.topdown.TopDownState;
	
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class SideScrollerState extends FlxState
	{
		public static const NAME: String = "SideScrollerState";
		
		private var levelCollisions: FlxGroup;
		private var floorBounds: FlxRect;
		
		public var floorTop: FlxObject;
		public var floorBottom: FlxObject;
		
		// The players.
		private var player1: PlayerSideScroller;
		private var players: FlxGroup;
		
		private var attackGroup: FlxGroup;
		
		private var timeRemainingText:FlxText;
		private var livesText:FlxText;
		
		// The number of seconds per level.
		private const LEVEL_TIME:Number = 99;
		private var timeRemaining:Number = LEVEL_TIME;
		
		private var gameOver:Boolean = false;
		
		private var debugConfig:MinimalConfigurator;
		
		private static var gamepad: XboxController;
		
		private var boss: FlxSprite;
		private var enemies: FlxGroup;
 
        override public function create():void
        {
			XboxInput.setup();
			
            FlxG.bgColor = 0xffaaaaaa;
			
			players = new FlxGroup(2);
			attackGroup = new FlxGroup();
			
			// Load map.
			var level1: SideScrollerLevel = new SideScrollerLevel1();
			FlxG.worldBounds = level1.addBackgroundLayers(this);
			floorBounds = level1.addPlayLayer(this);
			setMapBoundaries();
			
			addPlayer();
			
			boss = new FlxSprite(1000, FlxG.height - 175);
			boss.loadGraphic(Assets.graphics.BizzaroWorldBoss, true, true, 402, 175);
			boss.addAnimation("move", [0, 1], 10, true);
			boss.play("move");
			
			var penguin: FlxSprite = new FlxSprite(1500, FlxG.height - 300, Assets.graphics.Penguin);
			add(penguin);
			
			level1.addForegroundLayer(this);
			
			var camera: FlxCamera = FlxG.camera;
			camera.follow(player1);
			camera.bounds = new FlxRect(0, 0, FlxG.worldBounds.width, FlxG.worldBounds.height);
			
			// Add a label for the score.
			timeRemainingText = new FlxText(2, 2, 80);
			timeRemainingText.scrollFactor.x = timeRemainingText.scrollFactor.y = 0;
			timeRemainingText.shadow = 0xff000000;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			add(timeRemainingText);
			
			// Add a label for the lives.
			//livesText = new FlxText(FlxG.width - 45, 2, 45);
			//livesText.scrollFactor.x = livesText.scrollFactor.y = 0;
			//livesText.shadow = 0xff000000;
			//add(livesText);
			
			// Add a play instructions.
			var instructionsText:FlxText = new FlxText(FlxG.width / 2 - 50, 25, 200);
			instructionsText.text = "WASD or Arrow Keys to move";
			instructionsText.shadow = 0xff000000;
			add(instructionsText);
			
			enemies = new FlxGroup();
			enemies.add(boss);
			add(enemies);
			
			//FlxG.playMusic(Assets.audio.MusicTrack1, 0.8);
			
			FlxG.visualDebug = false;
			
			//var variableEditorWindow:VariableEditorWindow = new VariableEditorWindow();
			//debugConfig = variableEditorWindow.create(player1);
        }
		
		private function setMapBoundaries(): void 
		{
			levelCollisions = new FlxGroup(3);
			add(levelCollisions);
			
			floorTop = new FlxObject(0, floorBounds.top - (PlayerSideScroller.HEIGHT * PlayerSideScroller.MIN_SCALE_FACTOR), 
					FlxG.worldBounds.width, 10);
			floorTop.moves = false;
			floorTop.immovable = true;
			floorTop.allowCollisions = 0x1111;
			levelCollisions.add(floorTop);
			
			floorBottom = new FlxObject(0, floorBounds.bottom, FlxG.worldBounds.width, 10);
			floorBottom.moves = false;
			floorBottom.immovable = true;
			floorBottom.allowCollisions = 0x1111;
			levelCollisions.add(floorBottom);
			
			// Add hidden walls to prevent players from moving past the edge of the world.
			var leftWall: FlxObject = new FlxObject( -10, 0, 10, 500);
			leftWall.immovable = true;
			leftWall.moves = false;
			levelCollisions.add(leftWall);
			
			var rightWall: FlxObject = new FlxObject(FlxG.worldBounds.width, 0, 10, 500);
			rightWall.immovable = true;
			rightWall.moves = false;
			levelCollisions.add(rightWall);
		}
		
		private function addPlayer(): void
		{
			var startX: int = 30;
			var startY: int = 545 - PlayerSideScroller.HEIGHT;
			player1 = new PlayerSideScroller(this, attackGroup, startX, startY, floorBounds, 1);
			players.add(player1);
			add(player1);
		}
		
		override public function update(): void
		{
			if (gameOver)
			{
				return;
			}
			
			//gamepad = XboxInput.getController(0);
			//if (gamepad != null)
			//{
				//trace("Gamepad found");
				//trace("A: " + gamepad.buttonIsDown(XboxController.A));
			//}
			//else
			//{
				//trace("Gamepad not found");
			//}
			
			// Process collisions.
			FlxG.collide(levelCollisions, players);
			FlxG.overlap(players, attackGroup, onAttackHit);
			FlxG.collide(levelCollisions, player1.particleGroup);
			FlxG.collide(player1, player1.jumpFloor, player1.onJumpComplete);
			FlxG.collide(player1, enemies);
			
			super.update();
			
			timeRemaining -= FlxG.elapsed;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			
			boss.x -= 0.5;
			
			//livesText.text = "Lives: " + player.getLives();
			
			// Debugging: Switch between states.
			if (FlxG.keys.ESCAPE && FlxG.debug)
			{
				FlxG.switchState(App.gameStates[TopDownState.NAME]);
			}
		}
		
		private function onGameOver(): void
		{
			FlxG.mouse.show();
            FlxG.switchState(App.gameStates[LoseMenuState.NAME]);
		}
		
		private function onAttackHit(player: PlayerSideScroller, attack: AttackProjectile): void
		{
			if (player != attack.parent)
			{
				attack.hit(player);
			}
		}
		
		public override function destroy(): void
		{
		}
	}
}