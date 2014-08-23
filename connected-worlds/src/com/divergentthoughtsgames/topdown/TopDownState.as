package com.divergentthoughtsgames.topdown {
	
	import com.divergentthoughtsgames.assets.SideScrollerLevel1;
	import flash.display3D.textures.RectangleTexture;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.FlxSound;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
		
	import net.pixelpracht.tmx.*;
	
	import com.bit101.utils.MinimalConfigurator;
	import com.bit101.components.Component;
	import com.bit101.components.InputText;
	
	import com.divergentthoughtsgames.assets.Assets;
	import com.divergentthoughtsgames.VariableEditorWindow;
	import com.divergentthoughtsgames.topdown.PlayerTopDown;
	import com.divergentthoughtsgames.*;
	import com.divergentthoughtsgames.sidescroller.SideScrollerState;
	import com.divergentthoughtsgames.audio.SoundManager;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class TopDownState extends FlxState
	{
		public static const NAME: String = "TopDownState";
		
		// The level's map.
		private var level:FlxTilemap;
		
		// Entities.
		private var player:PlayerTopDown;
		private var ghosts:FlxGroup;
		
		// Sounds.
		private var bulletHitSounds:Vector.<Class>;
		private var hitSounds:Vector.<Class>;
		private var hitSoundTimer:FlxDelay;
		
		private var timeRemainingText:FlxText;
		private var livesText:FlxText;
		
		private var instructionsText:FlxText;
		
		// The number of seconds per level.
		private const LEVEL_TIME:Number = 999;
		private var timeRemaining:Number = LEVEL_TIME;
		
		private var gameOver:Boolean = false;
		
		private var debugConfig:MinimalConfigurator;
		
		private var previouslyLoaded: Boolean = false;
		
		private var usableManager: UsableManager;
		
		private var currentDialog: Dialog;
 
        override public function create():void
        {
            FlxG.bgColor = 0xffaaaaaa;
			
			if (!previouslyLoaded)
			{
				loadMap();
			
				var startX:int = 114;
				var startY:int = 2316;
				
				player = new PlayerTopDown(this, level, startX, startY);
				add(player);
				
				addUsables();
				
				// For testing.
				showDialog(Assets.graphics.Quest1Dialog1);
			}
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			FlxG.worldBounds = level.getBounds();
			FlxG.worldBounds.width = level.width + 32;
			
			addMinimap();
			
							// Add a play instructions.
				//instructionsText = new FlxText(startX - 150, startY - 300, 300);
				//instructionsText.size = 15;
				//instructionsText.text = "WASD or Arrow Keys to move Mouse click or spacebar to shoot";
				//instructionsText.shadow = 0xff000000;
				//add(instructionsText);
			
			//ghosts = new FlxGroup(3);
			//ghosts.add(new Ghost(this, level, startX - 100, startY - 100, player));
			//ghosts.add(new Ghost(this, level, startX + 100, startY, player));
			//ghosts.add(new Ghost(this, level, startX, startY + 100, player));
			//add(ghosts);
			
			// Add a label for the score.
			timeRemainingText = new FlxText(2, 2, 80);
			timeRemainingText.scrollFactor.x = timeRemainingText.scrollFactor.y = 0;
			timeRemainingText.shadow = 0xff000000;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			add(timeRemainingText);
			
			// Add a label for the lives.
			livesText = new FlxText(FlxG.width / FlxG.camera.getScale().x - 45,  4, 45);
			livesText.scale = FlxG.camera.getScale();
			livesText.scrollFactor.x = livesText.scrollFactor.y = 0;
			livesText.shadow = 0xff000000;
			livesText.antialiasing = true;
			add(livesText);
				
			add(new SoundManager(player, level));
			
			//FlxG.camera.flash(0xffffffff, 1.5);
			
			// Add the variable editor window. Remove this for release builds.
			var variableEditorWindow:VariableEditorWindow = new VariableEditorWindow();
			debugConfig = variableEditorWindow.create(player);
			
			previouslyLoaded = true;
        }
		
		public function showDialog(dialogTextClass: Class): void
		{
			var dialogBox: Dialog = new Dialog(this, dialogTextClass);
			dialogBox.setPosition(FlxG.width / 2 - dialogBox.width / 2, 100);
			add(dialogBox);
			currentDialog = dialogBox;
		}
		
		public function removeInstructions(): void
		{
			if (instructionsText != null)
			{
				remove(instructionsText, true);
				instructionsText = null;
			}
		}
		
		private function addMinimap(): void
		{
			var minimap: FlxCamera = new FlxCamera(0, 0, level.width / 2, level.height / 2, 0.125);
			minimap.follow(player, FlxCamera.STYLE_LOCKON);
			minimap.bounds = new FlxRect(0, 0, level.width, level.height);
			FlxG.addCamera(minimap);
			
			var minimapBorder: FlxSprite = new FlxSprite();
			minimapBorder.makeGraphic(151, 151, 0xff000000);
			minimapBorder.scrollFactor.x = minimapBorder.scrollFactor.y = 0;
			add(minimapBorder);
		}
		
		private function loadMap(): void 
		{
			var xml:XML = new XML(new Assets.level.Level1Xml());
			var tmx:TmxMap = new TmxMap(xml);
			
			var tileset:TmxTileSet = tmx.getTileSet('warcraft-tileset-2');
			var mapCsv:String = tmx.getLayer('map').toCsv(tileset);
			level = new FlxTilemap();
			level.loadMap(mapCsv, Assets.level.Level1Image, 32, 32, FlxTilemap.OFF, 0, 0, 155); // Formerly 196
			add(level);
			
			var scaleX:Number = FlxG.camera.getScale().x;
			var scaleY:Number = FlxG.camera.getScale().y;
			
			// TODO: For testing - move to the correct area later.
			var toastMan: FlxSprite = new FlxSprite(200, 1650, Assets.graphics.ToastMan);
			add(toastMan);
			
			var town1: FlxSprite = new FlxSprite(200, 1800, Assets.graphics.Town1);
			add(town1);
			
			//FlxG.camera.setBounds(0, 0, level.width * scaleX - 410, level.height * scaleY - 460, true);
		}
		
		private function addUsables(): void
		{
			usableManager = new UsableManager(player);
			add(usableManager);
			
			var cave: StateSwitchTrigger = new StateSwitchTrigger("Cave", new Rectangle(0, 2252, 110, 140), new SideScrollerState());
			usableManager.add(cave);
		}
		
		override public function update(): void
		{
			if (gameOver)
			{
				return;
			}
			
			super.update();
			
			// Process collisions.
			FlxG.collide(level, player);
			
			timeRemaining -= FlxG.elapsed;
			timeRemainingText.text = "Time: " + Math.round(timeRemaining);
			gameOver = ((timeRemaining <= 0) ? true : 
					(player.getLives() == 0) ? true : false);
			if (gameOver)
			{
				onGameOver();
			}
			
			livesText.text = "Lives: " + player.getLives();
			
			// Debugging: Switch between states.
			if (FlxG.keys.ESCAPE && FlxG.debug)
			{
				FlxG.switchState(App.gameStates[SideScrollerState.NAME]);
			}
			
			if (FlxG.keys.E && currentDialog != null)
			{
				currentDialog.destroy();
				remove(currentDialog);
			}
		}
		
		public override function destroy(): void
		{
		}
		
		private function onGameOver() : void
		{
			FlxG.mouse.show();
            FlxG.switchState(new LoseMenuState());
		}
	}
}