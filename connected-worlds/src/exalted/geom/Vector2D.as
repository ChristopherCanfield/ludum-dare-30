package exalted.geom
{
	
	public class Vector2D
	{
		
		private var _x:Number;
		private var _y:Number;
		
		
		public function Vector2D(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
		
		
		public function toString():String
		{
			return "(x: " + x + ", y: " + y + ")";
		}
		
		
		public function get x():Number{ return _x; }
		public function set x(value:Number):void{ _x = value; }
		public function get y():Number{ return _y; }
		public function set y(value:Number):void{ _y = value; }
		public function get length():Number{ return Math.sqrt(x * x + y * y); }
		public function get angle():Number{ return Math.atan2(y, x); }
		
	}
	
}