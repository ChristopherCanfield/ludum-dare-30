package com.divergentthoughtsgames.topdown {
	
	import com.bit101.utils.MinimalConfigurator;
	
	import com.divergentthoughtsgames.*;
	import com.divergentthoughtsgames.assets.Assets;
	import com.divergentthoughtsgames.audio.SoundManager;
	import com.divergentthoughtsgames.beatemup.BeatEmUpState;
	import com.divergentthoughtsgames.topdown.PlayerTopDown;
	
	import net.pixelpracht.tmx.*;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class TopDownState extends FlxState
	{
		public static const NAME: String = "TopDownState";
		
		// The level's map.
		private var level: FlxGroup;
		private var overworld: FlxSprite;
		
		// Entities.
		private var player:PlayerTopDown;
		
		// Sounds.
		private var bulletHitSounds:Vector.<Class>;
		private var hitSounds:Vector.<Class>;
		private var hitSoundTimer:FlxDelay;
		
		private var timeRemainingText:FlxText;
		private var livesText:FlxText;
		
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
			
				var startX:int = 1144;
				var startY:int = 1185;
				
				player = new PlayerTopDown(this, startX, startY);
				add(player);
				
				addUsables();
				
				// For testing.
				showDialog(Assets.graphics.Quest1Dialog1);
			}
			
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
			FlxG.camera.setBounds(0, 0, overworld.width, overworld.height);
			FlxG.worldBounds = new FlxRect(0, 0, overworld.width, overworld.height);
			
			var oldWestBox: FlxSprite = new FlxSprite(300, 200, Assets.graphics.OldWestTextBox);
			oldWestBox.scrollFactor.x = oldWestBox.scrollFactor.y = 0;
			add(oldWestBox);
			
			//addMinimap();
			
			// Add a label for the lives.
			livesText = new FlxText(FlxG.width / FlxG.camera.getScale().x - 45,  4, 45);
			livesText.scale = FlxG.camera.getScale();
			livesText.scrollFactor.x = livesText.scrollFactor.y = 0;
			livesText.shadow = 0xff000000;
			livesText.antialiasing = true;
			add(livesText);
				
			add(new SoundManager(player));
			
			//FlxG.camera.flash(0xffffffff, 1.5);
			
			// Add the variable editor window. Remove this for release builds.
			//var variableEditorWindow:VariableEditorWindow = new VariableEditorWindow();
			//debugConfig = variableEditorWindow.create(player);
			
			FlxG.debug = true;
			FlxG.visualDebug = true;
			
			previouslyLoaded = true;
        }
		
		public function showDialog(dialogTextClass: Class): void
		{
			var dialogBox: Dialog = new Dialog(this, dialogTextClass);
			dialogBox.setPosition(FlxG.width / 2 - dialogBox.width / 2, 100);
			add(dialogBox);
			currentDialog = dialogBox;
		}
		
		private function addMinimap(): void
		{
			var minimap: FlxCamera = new FlxCamera(0, 0, FlxG.worldBounds.width / 1.5, FlxG.worldBounds.height / 1.5, 0.1);
			minimap.follow(player, FlxCamera.STYLE_LOCKON);
			minimap.bounds = new FlxRect(0, 0, FlxG.worldBounds.width, FlxG.worldBounds.height);
			FlxG.addCamera(minimap);
			
			var minimapBorder: FlxSprite = new FlxSprite();
			minimapBorder.makeGraphic(100, 100, 0xff000000);
			minimapBorder.scrollFactor.x = minimapBorder.scrollFactor.y = 0;
			add(minimapBorder);
		}
		
		private function loadMap(): void 
		{
			level = new FlxGroup();
			
			//var scaleX:Number = FlxG.camera.getScale().x;
			//var scaleY:Number = FlxG.camera.getScale().y;
			
			overworld = new FlxSprite(0, 0, Assets.graphics.Overworld);
			add(overworld);
			
			//var pond: FlxSprite = new FlxSprite(0, 1754)
			//pond.loadGraphic(Assets.graphics.Pond, true, false, overworld.width, overworld.height - 1754);
			//pond.addAnimation("animation", [0, 1, 2], 8, true);
			//pond.play("animation");
			//add(pond);
			
			var town1: FlxSprite = new FlxSprite(910, 758, Assets.graphics.Town1);
			town1.immovable = true;
			town1.width = 500;
			town1.height = 150;
			town1.offset.x = 10;
			town1.offset.y = 5;
			
			level.add(town1);
			add(town1);
			
			var town2: FlxSprite = new FlxSprite(350, 912, Assets.graphics.Town2);
			level.add(town2);
			town2.immovable = true;
			town2.width = 338;
			town2.height = 440
			town2.offset.y = 5;
			add(town2);
			
			var town2BoundingBox2: FlxObject = new FlxObject(500, 1011, 220, 215);
			town2BoundingBox2.immovable = true;
			level.add(town2BoundingBox2);
			add(town2BoundingBox2);
			
			var town2BoundingBox3: FlxObject = new FlxObject(650, 1055, 100, 100);
			town2BoundingBox3.immovable = true;
			level.add(town2BoundingBox3);
			add(town2BoundingBox3);
			
			var town2BoundingBox4: FlxObject = new FlxObject(675, 915, 110, 200);
			town2BoundingBox4.immovable = true;
			level.add(town2BoundingBox4);
			add(town2BoundingBox4);
			
			var water1: FlxObject = new FlxObject(0, 1776, 332, 63);
			water1.immovable = true;
			level.add(water1);
			add(water1);
			
			var water2: FlxObject = new FlxObject(335, 1763, 1171, 113);
			water2.immovable = true;
			level.add(water2);
			add(water2);
			
			var water3: FlxObject = new FlxObject(1508, 1816, 143, 106);
			water3.immovable = true;
			level.add(water3);
			add(water3);
			
			var water4: FlxObject = new FlxObject(1650, 1853, 366, 68);
			water4.immovable = true;
			level.add(water4);
			add(water4);
			
			var water5: FlxObject = new FlxObject(1180, 1740, 210, 50);
			water5.immovable = true;
			level.add(water5);
			add(water5);
			
			var horse: FlxSprite = new FlxSprite(1425, 868, Assets.graphics.HorseFront);
			add(horse);
			
			//FlxG.camera.setBounds(0, 0, level.width * scaleX - 410, level.height * scaleY - 460, true);
		}
		
		private function addUsables(): void
		{
			usableManager = new UsableManager(player);
			add(usableManager);
			
			//var cave: StateSwitchTrigger = new StateSwitchTrigger("Cave", new Rectangle(0, 2252, 110, 140), new SideScrollerState());
			//usableManager.add(cave);
		}
		
		override public function update(): void
		{
			if (gameOver)
			{
				return;
			}
			
			player.savePosition();
			super.update();
			
			// Process collisions.
			FlxG.overlap(player, level, onLevelCollide, null);

			if (gameOver)
			{
				onGameOver();
			}
			
			livesText.text = "Lives: " + player.getLives();
			
			// Debugging: Switch between states.
			if (FlxG.keys.ESCAPE && FlxG.debug)
			{
				FlxG.switchState(App.gameStates[BeatEmUpState.NAME]);
			}
			
			if (FlxG.keys.E && currentDialog != null)
			{
				currentDialog.destroy();
				remove(currentDialog);
			}
		}
		
		private function onLevelCollide(player: PlayerTopDown, object2: FlxObject): Boolean
		{
			if (object2 is FlxSprite)
			{
				var sprite: FlxSprite = object2 as FlxSprite; 
				if (FlxCollision.pixelPerfectCheck(player, sprite))
				{
					player.x = player.previousX;
					player.y = player.previousY;
					player.velocity.x = player.velocity.y = 0;
				}
			}
			else
			{
				FlxObject.separate(player, object2);
			}
			return false;
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