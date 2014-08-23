package com.divergentthoughtsgames 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class UsableManager extends FlxBasic
	{
		private var usables: Vector.<Usable>;
		private var player: FlxObject;
		
		public function UsableManager(player: FlxObject) 
		{
			usables = new Vector.<Usable>();
			this.player = player;
		}
		
		public function add(usable: Usable): void
		{
			usables.push(usable);
		}
		
		override public function update(): void
		{
			if (FlxG.keys.E)
			{
				for each (var usable:Usable in usables)
				{
					if (usable.getBoundingBox().contains(player.x, player.y))
					{
						usable.useObject();
						// Only use one object at a time.
						return;
					}
				}
			}
		}
	}
}