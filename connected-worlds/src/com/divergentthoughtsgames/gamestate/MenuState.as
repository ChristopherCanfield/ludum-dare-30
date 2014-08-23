package com.divergentthoughtsgames.gamestate {
	import org.flixel.FlxState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;
 
        public function MenuState()
        {
        }
 
        override public function create():void
        {
            FlxG.mouse.show();
            startButton = new FlxButton(FlxG.width / 2.0 - 150, 90, "Start Game", startGame);
			startButton.scale.x = startButton.scale.y = 2.0;
            add(startButton);
        }
 
        private function startGame():void
        {
            FlxG.mouse.hide();
            FlxG.switchState(new TopDownState());
        }
	}

}