package com.divergentthoughtsgames {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	import com.divergentthoughtsgames.App;
	import com.divergentthoughtsgames.topdown.TopDownState;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class LoseMenuState extends FlxState
	{
		public static const NAME: String = "LoseMenuState";
		
		private var startButton:FlxButton;
 
        public function LoseMenuState()
        {
        }
 
        override public function create():void
        {
			FlxG.bgColor = 0xff000000;
            FlxG.mouse.show();
            
			var loseText:FlxText = new FlxText(FlxG.width / 2 - 50, 20, 160, "You lose!");
			loseText.size = 18;
			loseText.color = 0xffff0000;
			add(loseText);
			
			startButton = new FlxButton(120, 90, "New Game", startGame);
			add(startButton);
        }
 
        private function startGame():void
        {
            FlxG.mouse.hide();
            FlxG.switchState(App.gameStates[TopDownState.NAME]);
        }
	}
}