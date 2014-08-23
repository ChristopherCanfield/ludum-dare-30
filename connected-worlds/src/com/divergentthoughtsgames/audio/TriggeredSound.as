package com.divergentthoughtsgames.audio {
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSound;
	
	/**
	 * A sound that triggers one or more time when the player reaches an area.
	 * @author Christopher D. Canfield
	 */
	public class TriggeredSound extends AbstractManagedSound
	{
		public static const UNLIMITED_PLAYS: uint = 9999999;
		
		/** The sound triggers when the player is within the bounding box. **/
		public var boundingBox: Rectangle;
		
		
		public function TriggeredSound(name: String)
		{
			super(name);
		}
		
		override public function update(xPosition: Number, yPosition: Number): void
		{
			if (!reachedMaxPlayCount() && !soundInstance.active)
			{
				if (boundingBox.contains(xPosition, yPosition))
				{
					soundInstance.play();
					playCount++;
				}
			}
		}
	}
}