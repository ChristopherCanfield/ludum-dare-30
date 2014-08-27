package com.divergentthoughtsgames.audio {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.flixel.FlxBasic;
	import org.flixel.FlxRect;
	import org.flixel.FlxSound;
	import org.flixel.FlxTilemap;
	
	import com.divergentthoughtsgames.topdown.PlayerTopDown;
	import com.divergentthoughtsgames.assets.Assets;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class SoundManager extends FlxBasic
	{
		private var player: PlayerTopDown;
		
		private const sounds: Vector.<ManagedSound> = new Vector.<ManagedSound>();
		
		public function SoundManager(player: PlayerTopDown)
		{
			this.player = player;
			
			//var oceanWaves: AmbientSound = new AmbientSound("Ocean Waves");
			//oceanWaves.soundInstance = FlxG.loadSound(Assets.audio.OceanWaves, 1.0, true, false, false);
			//oceanWaves.boundingBox = new Rectangle(0, 1745, FlxG.worldBounds.width, FlxG.worldBounds.height - 1745);
			//oceanWaves.fadeDistance = 100;
			//oceanWaves.maxPlays = TriggeredSound.UNLIMITED_PLAYS;
			//oceanWaves.maxVolume = 1.0;
			//sounds.push(oceanWaves);
			//
			//var churchBells: TriggeredSound = new TriggeredSound("Church Bells");
			//churchBells.soundInstance = FlxG.loadSound(Assets.audio.ChurchBells, 1.0, false, true, false);
			//churchBells.boundingBox = new Rectangle(0, 1500, level.width, 50);
			//churchBells.maxPlays = 1;
			//churchBells.maxVolume = 1.0;
			//sounds.push(churchBells);
			//
			//var outdoorNoise: AmbientSound = new AmbientSound("Outdoor Noise");
			//outdoorNoise.soundInstance = FlxG.loadSound(Assets.audio.AmbientOutdoorNoise, 1.0, true, false, false);
			//outdoorNoise.boundingBox = new Rectangle(0, 0, level.width, 2047);
			//outdoorNoise.fadeDistance = 100;;
			//outdoorNoise.maxPlays = TriggeredSound.UNLIMITED_PLAYS;
			//outdoorNoise.maxVolume = 1.0;
			//sounds.push(outdoorNoise);
		}
		
		override public function update(): void
		{
			for each (var sound: ManagedSound in sounds)
			{
				sound.update(player.x, player.y);
			}
		}
	}
}