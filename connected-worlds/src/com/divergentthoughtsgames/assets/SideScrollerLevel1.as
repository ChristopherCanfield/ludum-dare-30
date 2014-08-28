package com.divergentthoughtsgames.assets {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class SideScrollerLevel1 implements SideScrollerLevel
	{
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-background-0.png')]
		private static const Level_1_Background_0: Class;
		
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-background-1.png')]
		private static const Level_1_Background_1: Class;
		
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-background-2.png')]
		private static const Level_1_Background_2: Class;
		
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-background-3.png')]
		private static const Level_1_Background_3: Class;
		
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-play-layer.png')]
		private static const Level_1_Play_Layer: Class;
		
		[Embed(source = '../../../../res/art/side-scroller-level-1/level-1-foreground.png')]
		private static const Level_1_Foreground: Class;
		
		
		public function addBackgroundLayers(gameState: FlxState): FlxRect
		{
			var layer0: FlxSprite = new FlxSprite(0, 0, Level_1_Background_0);
			layer0.scrollFactor.x = 0.65;
			gameState.add(layer0);
			
			var layer1: FlxSprite = new FlxSprite(0, 0, Level_1_Background_1);
			layer1.scrollFactor.x = 0.75;
			gameState.add(layer1);
			
			var layer2: FlxSprite = new FlxSprite(0, 0, Level_1_Background_2);
			layer2.scrollFactor.x = 0.85;
			gameState.add(layer2);
			
			var layer3: FlxSprite = new FlxSprite(0, 0, Level_1_Background_3);
			layer3.scrollFactor.x = 0.95;
			gameState.add(layer3);
			
			return new FlxRect(0, 0, layer0.width, layer0.height);
		}
		
		public function addPlayLayer(gameState: FlxState): FlxRect
		{
			var playLayer: FlxSprite = new FlxSprite(0, 0, Level_1_Play_Layer);
			gameState.add(playLayer);
			
			return new FlxRect(0, 410, playLayer.width, 240);
		}
		
		public function addForegroundLayer(gameState: FlxState): void
		{
			var foregroundLayer: FlxSprite = new FlxSprite(0, 0, Level_1_Foreground);
			gameState.add(foregroundLayer);
		}
	}
}