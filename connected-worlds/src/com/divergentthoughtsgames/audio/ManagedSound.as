package com.divergentthoughtsgames.audio {
	
	/**
	 * Managed Sounds are updated by the Sound Manager.
	 * @author Christopher D. Canfield
	 */
	public interface ManagedSound 
	{
		function update(xPosition: Number, yPosition: Number): void;
	}
}