package com.divergentthoughtsgames.util 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class HashSet 
	{
		private var backingDictionary : Dictionary;
		private var length : int;
		
		public function HashSet() 
		{	
			backingDictionary = new Dictionary();
			length = 0;
		}
		
		public function add(e:Object) : void
		{
			backingDictionary[e] = true;
			length++;
		}
		
		public function contains(e:Object) : Boolean
		{
			return e in backingDictionary;
		}
		
		public function remove(e:Object) : void
		{
			if (contains(e))
			{
				delete backingDictionary[e];
				length--;
			}
		}
		
		public function size() : int
		{
			return length;
		}
	}
}