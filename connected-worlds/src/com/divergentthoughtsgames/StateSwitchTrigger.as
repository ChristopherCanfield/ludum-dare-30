package com.divergentthoughtsgames {
	import flash.geom.Rectangle;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	
	/**
	 * Triggers entry into a different game state.
	 * @author Christopher D. Canfield
	 */
	public class StateSwitchTrigger implements Usable
	{
		private var name: String;
		private var boundingBox: Rectangle;
		private var state: FlxState;
		
		public function StateSwitchTrigger(name: String, boundingBox: Rectangle, state: FlxState)
		{	
			this.boundingBox = boundingBox;
			this.state = state;
			this.name = name;
		}
		
		public function getBoundingBox(): Rectangle
		{
			return boundingBox;
		}
		
		public function useObject(): void
		{
			if (FlxG.debug)
			{
				trace("Used " + toString());
			}
			
			FlxG.switchState(state);
		}
		
		public function toString(): String
		{
			return name;
		}
	}
}