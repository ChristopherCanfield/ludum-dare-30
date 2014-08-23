package exalted.input
{

	import flash.ui.GameInput;
	import flash.ui.GameInputDevice;
	import flash.events.GameInputEvent;
	
	
	public class XboxInput
	{
		
		private static var _gameInput:GameInput = new GameInput();
		private static var _controllers:Vector.<XboxController> = new <XboxController>[];
		
		
		public static function setup():void
		{
			_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, _updateDevices);
			_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, _updateDevices);
		}
		
		
		private static function _updateDevices(e:GameInputEvent):void
		{
			_controllers = new <XboxController>[];
			for(var i:int = 0; i < GameInput.numDevices; i++)
			{
				var device:GameInputDevice = GameInput.getDeviceAt(i);
				device.enabled = true;
				
				_controllers.push( new XboxController(device) );
			}
			
			trace("Device list updated.");
		}
		
		
		public static function getController(index:int):XboxController
		{
			if(index >= _controllers.length) return null;
			
			return _controllers[index];
		}
		
	}
	
}