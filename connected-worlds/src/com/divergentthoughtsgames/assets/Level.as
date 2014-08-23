package com.divergentthoughtsgames.assets 
{
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Level 
	{
		[Embed(source = '../../../../res/map/warcraft-map.tmx', 
				mimeType="application/octet-stream")] 
		public const Level1Xml:Class;
		
		[Embed(source = '../../../../res/map/warcraft-tileset-2.png')]
		public const Level1Image:Class;
	}
}