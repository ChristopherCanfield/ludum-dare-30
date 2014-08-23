package com.divergentthoughtsgames {
	
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class AttackProjectile extends FlxSprite
	{
		public var damage: Number;
		public var parent: FlxSprite;
		public var range: Number;
		public var distanceTravelled: Number = 0;
		
		/** Should be -1 (right) or 1 (left). **/
		public var direction: int;
		
		public function AttackProjectile(x: Number = 0, y: Number = 0) 
		{
			super(x, y);
		}
		
		final public function hit(player: Player): void
		{
			player.health -= damage;
			kill();
			
			onHit();
		}
		
		/**
		 * Override to hook into the attackProjectile.hit(Player) method.
		 */
		public function onHit(): void {}
	}
}