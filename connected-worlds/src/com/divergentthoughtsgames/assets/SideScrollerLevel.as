package com.divergentthoughtsgames.assets 
{
	import org.flixel.FlxRect;
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public interface SideScrollerLevel 
	{
		/**
		 * 
		 * @param	gameState
		 * @return the bounds of the level.
		 */
		function addBackgroundLayers(gameState: FlxState): FlxRect;
		
		/**
		 * 
		 * @param	gameState
		 * @return the bounds of the play area (i.e., the floor).
		 */
		function addPlayLayer(gameState: FlxState): FlxRect;
		
		function addForegroundLayer(gameState: FlxState): void;
	}	
}