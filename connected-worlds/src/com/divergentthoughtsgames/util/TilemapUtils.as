package com.divergentthoughtsgames.util 
{
	import flash.utils.Dictionary;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class TilemapUtils 
	{
		private function TilemapUtils() 
		{
		}
	
		//public static function adjustTileIndices(data: Array, offset: int): void
		//{
			//var size = data.length;
			//for (var i:int = 0; i < size; ++i)
			//{
				//data[i] += offset;
			//}
		//}
		
		public static function setTilemapCollisions(map: FlxTilemap, collisionIndices: HashSet): void
		{
			var size:int = map.widthInTiles * map.heightInTiles;
			for (var i:int = 0; i < size; ++i)
			{
				var collision:uint = (collisionIndices.contains(i)) ? 0x1111 : 0;
				map.setTileProperties(i, collision);
			}
		}
	}

}