package com.divergentthoughtsgames
{
	import flash.display.Sprite;
	import flash.events.Event;

	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	[Frame(factoryClass="com.divergentthoughtsgames.Preloader")]
	public class Main extends Sprite 
	{
		public function Main():void
        {
            if (stage)
            {
                init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }
 
        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
 
			App.initialize();
			
            var game:Game = new Game();
            addChild(game)
		}
	}
}