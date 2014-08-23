package com.divergentthoughtsgames {
	import org.flixel.FlxState;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	
	import com.divergentthoughtsgames.App;
	import com.divergentthoughtsgames.topdown.TopDownState;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class MenuState extends FlxState
	{
		public static const NAME: String = "MenuState";
		
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
            FlxG.switchState(App.gameStates[TopDownState.NAME]);
        }
	}

}