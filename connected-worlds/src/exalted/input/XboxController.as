package exalted.input
{

	import flash.ui.GameInputDevice;
	import flash.ui.GameInputControl;
	import exalted.geom.Vector2D;
	
	
	public class XboxController
	{
		
		public static const A:String = "BUTTON_4";
		public static const B:String = "BUTTON_5";
		public static const X:String = "BUTTON_6";
		public static const Y:String = "BUTTON_7";
		public static const LB:String = "BUTTON_8";
		public static const RB:String = "BUTTON_9";
		public static const LT:String = "BUTTON_10";
		public static const RT:String = "BUTTON_11";
		public static const BACK:String = "BUTTON_12";
		public static const START:String = "BUTTON_13";
		public static const LS:String = "BUTTON_14";
		public static const RS:String = "BUTTON_15";
		public static const UP:String = "BUTTON_16";
		public static const DOWN:String = "BUTTON_17";
		public static const LEFT:String = "BUTTON_18";
		public static const RIGHT:String = "BUTTON_19";
		public static const LSX:String = "AXIS_0";
		public static const LSY:String = "AXIS_1";
		public static const RSX:String = "AXIS_2";
		public static const RSY:String = "AXIS_3";

		
		private var _device:GameInputDevice;
		private var _controls:Object = { };
		private var _leftStick:Vector2D;
		private var _rightStick:Vector2D;
		
		
		public function XboxController(device:GameInputDevice)
		{
			_device = device;
			
			_leftStick = new Vector2D();
			_rightStick = new Vector2D();
			
			for(var i:int = 0; i < device.numControls; i++)
			{
				var control:GameInputControl = _device.getControlAt(i);
				_controls[control.id] = control;
			}
		}
		
		
		public function getControl(id:String):GameInputControl
		{
			return _controls[id] !== undefined ? _controls[id] : null;
		}
		
		
		public function buttonIsDown(buttonId:String):Boolean
		{
			return _controls[buttonId].value === 1;
		}
		
		
		public function get leftStick():Vector2D
		{
			_leftStick.x = _controls[LSX].value;
			_leftStick.y = -_controls[LSY].value;
			
			return _leftStick;
		}
		
		
		public function get rightStick():Vector2D
		{
			_rightStick.x = _controls[RSX].value;
			_rightStick.y = -_controls[RSY].value;
			
			return _rightStick;
		}
		
		
		public function get leftTriggerPressure():Number{ return _controls[LT].value; }
		public function get rightTriggerPressure():Number{ return _controls[RT].value; }
		
	}
	
}