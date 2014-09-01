package com.divergentthoughtsgames {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	import com.divergentthoughtsgames.topdown.*;
	import com.divergentthoughtsgames.beatemup.*;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class App 
	{
		/**
		 * HashMap containing the game states.
		 * Key: state name (String).
		 * Value: the FlxState object.
		 */
		public static var gameStates: Object = new Object();
		
		public static function initialize(): void
		{
			App.gameStates[BeatEmUpState.NAME] = new BeatEmUpState();
			App.gameStates[TopDownState.NAME] = new TopDownState();
			
			FlxG.debug = true;
		}
	}
}