package com.divergentthoughtsgames 
{
	import org.flixel.FlxGame;
	
	import com.divergentthoughtsgames.MenuState;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Game extends FlxGame
	{
		
		public function Game()
        {
            super(900, 656, MenuState, 1);
        }
	}
}