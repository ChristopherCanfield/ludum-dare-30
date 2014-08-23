package com.divergentthoughtsgames 
{
	import org.flixel.FlxGame;
	
	import com.divergentthoughtsgames.gamestate.MenuState;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Game extends FlxGame
	{
		
		public function Game()
        {
            super(960, 720, MenuState, 1.25);
        }
	}
}