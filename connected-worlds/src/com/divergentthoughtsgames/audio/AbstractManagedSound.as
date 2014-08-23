package com.divergentthoughtsgames.audio 
{
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class AbstractManagedSound implements ManagedSound
	{	
		/** The maximum number of times this sound will play. **/
		internal var maxPlays: uint = 1;
		protected var playCount: uint = 0;
		
		/** The sound's volume, from 0 to 1.0. **/
		internal var maxVolume: Number;
		
		internal var soundInstance: FlxSound;
		
		private var name: String;
		
		public function AbstractManagedSound(name: String) 
		{
			this.name = name;
		}
		
		public function update(xPosition: Number, yPosition: Number): void
		{
		}
		
		public function reachedMaxPlayCount(): Boolean
		{
			return playCount >= maxPlays;
		}
		
		public function toString(): String
		{
			return name;
		}
	}
}