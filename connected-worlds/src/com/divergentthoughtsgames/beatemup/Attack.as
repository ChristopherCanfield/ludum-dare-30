package com.divergentthoughtsgames.beatemup {
	import flash.geom.Point;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class Attack 
	{
		public var range: int;
		
		public var speed: int;
		
		public var maxDamage: Number = 0;
		
		public var minDamage: Number = 0;
		
		public var ready: Boolean = true;
		
		/**
		 * The projectile's offset from the parent, specified from the upper right corner
		 * as the player is facing right.
		 */
		public var offset: Point = new Point();
		
		public var projectileWidth: int;
		public var projectileHeight: int;
		
		/** If true, a default visualization will be drawn when executed. **/
		public var debug: Boolean = false;
		
		private var parent: FlxSprite;
		private var attackGroup: FlxGroup;
		
		public var animationName: String;
		
		public function Attack(parent: FlxSprite, attackGroup: FlxGroup, animationName: String)
		{
			this.parent = parent;
			this.attackGroup = attackGroup;
			this.animationName = animationName;
		}
		
		public function execute(): void
		{
			var projectile: AttackProjectile = new AttackProjectile(calculateProjectileX(), parent.y + offset.y);
			projectile.width = projectileWidth;
			projectile.height = projectileHeight;
			projectile.visible = debug;
			var direction: int = (parent.facing == FlxObject.LEFT) ? -1 : 1;
			projectile.velocity.x = speed * direction;
			projectile.damage = calculateAttackDamage();
			projectile.parent = parent;
			projectile.range = range;
			
			projectile.onUpdate = function(): void {
				projectile.distanceTravelled += Math.abs(projectile.velocity.x * FlxG.elapsed);
				
				if (projectile.distanceTravelled > projectile.range)
				{
					projectile.kill();
				}
			};
			
			attackGroup.add(projectile);
			FlxG.state.add(projectile);
			ready = false;
		}
		
		private function calculateProjectileX(): Number
		{
			return (parent.facing == FlxObject.RIGHT) ? parent.x + parent.width : parent.x;
		}
		
		private function calculateAttackDamage(): Number
		{
			var damageRange: Number = maxDamage - minDamage;
			return (maxDamage - (Math.random() * damageRange));
		}
	}
}