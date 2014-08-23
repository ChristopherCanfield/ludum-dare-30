package com.divergentthoughtsgames 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	
	import com.divergentthoughtsgames.assets.Assets;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Dialog extends FlxSprite
	{
		private var dialogBox: FlxSprite;
		private var gameState: FlxState;
		
		public function Dialog(gameState: FlxState, dialogTextImage:Class=null) 
		{
			super(0, 0, dialogTextImage);
		
			dialogBox = new FlxSprite(0, 0, Assets.graphics.TextBox);
			gameState.add(dialogBox);
			
			this.gameState = gameState;
			
			scrollFactor.x = scrollFactor.y = 0;
			dialogBox.scrollFactor.x = dialogBox.scrollFactor.y = 0;
		}
		
		public function setPosition(x: Number, y: Number): void
		{
			this.x = x;
			this.y = y;
			
			dialogBox.x = x;
			dialogBox.y = y;
		}
		
		override public function destroy(): void
		{
			gameState.remove(dialogBox);
		}
	}
}