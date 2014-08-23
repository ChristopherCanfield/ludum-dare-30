package com.divergentthoughtsgames.audio {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSound;
	
	/**
	 * A sound that only plays within a specified area.
	 * @author Christopher D. Canfield
	 */
	public class AmbientSound extends AbstractManagedSound
	{
		public static const UNLIMITED_PLAYS: uint = 9999999;
		
		/** 
		 * 	The sound plays at full volume within the bounding box. If the fade distance is set, 
		 *  the sound will fade out as the player crosses the bounding box's boundary, until the
		 *  distance from the edge of the bounding box is greater than the fade distance.
		 **/
		public var boundingBox: Rectangle;
		
		/** The distance that the sound fades in and out from the bounding box. **/
		public var fadeDistance: int = 0;
		
		
		public function AmbientSound(name: String)
		{
			super(name);
		}
		
		override public function update(xPosition: Number, yPosition: Number): void
		{
			if (!reachedMaxPlayCount())
			{
				var newVolume: Number = newVolume(xPosition, yPosition);
				if (newVolume > 0)
				{
					if (!soundInstance.active)
					{
						trace("Sound started: " + toString());
						soundInstance.play();
						playCount++;
					}
					
					soundInstance.volume = newVolume;
				}
				else if (newVolume <= 0 && soundInstance.active)
				{
					trace("Sound stopped: " + toString());
					soundInstance.stop();
				}
			}
		}
		
		/**
		 * Calculates a new volume from an x,y position.
		 * @param	xPosition the x position of the object.
		 * @param	yPosition the y position of the object.
		 * @return the new volume, from 0 to 1.0.
		 */
		private function newVolume(xPosition: Number, yPosition: Number): Number
		{
			if (!reachedMaxPlayCount())
			{
				if (boundingBox.contains(xPosition, yPosition))
				{
					return maxVolume;
				}
				
				var leftDistance: Number = boundingBox.left - xPosition;
				var rightDistance: Number = xPosition - boundingBox.right;
				var topDistance: Number = boundingBox.top - yPosition;
				var bottomDistance: Number = yPosition - boundingBox.bottom;
				
				var farthestDistance: Number = Math.max(leftDistance, rightDistance, topDistance, bottomDistance);
				if (farthestDistance > 0 && farthestDistance < fadeDistance)
				{
					return ((fadeDistance - farthestDistance) / fadeDistance);
				}
			}
			return 0;
		}
	}
}