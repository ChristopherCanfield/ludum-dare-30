package com.divergentthoughtsgames {
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public interface Usable 
	{
		function useObject(): void;
		function getBoundingBox(): Rectangle;
		function toString(): String;
	}
	
}