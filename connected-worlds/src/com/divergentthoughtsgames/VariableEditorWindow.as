package com.divergentthoughtsgames 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxG;
	
	import com.bit101.utils.MinimalConfigurator;
	
	import com.bit101.components.*;
	
	import com.divergentthoughtsgames.topdown.PlayerTopDown;
	
	/**
	 * ...
	 * @author Christopher D. Canfield
	 */
	public class VariableEditorWindow 
	{
		private var debugConfig:MinimalConfigurator;
		
		private var player:PlayerTopDown;
		
		/**
		 * Creates a window that can be used to edit in-game variables.
		 */
		public function create(player:PlayerTopDown) : MinimalConfigurator
		{
			Component.initStage(FlxG.stage);
			this.player = player;
            
            var xml:XML = <comps>
							<Window width="215" height="150" alpha="0.925" title="Editor" hasMinimizeButton="true" minimized="true">
								<Panel x="0" y="0" width="210" height="125">
									<HBox x="10" y="5">
										<VBox>
											<Label text="Player Max Speed:" width="125" event="keyup:onKeyUp"/>
											<Label text="Player Deceleration:"/>
											<Label text="???:"/>
											<Label text="???:"/>
											<PushButton label="Update" event="click:onClick"/>
										</VBox>
										<VBox spacing="7">
											<InputText id="playerMaxVelocity" width="40" event="keyUp:onKeyUp"/>
											<InputText id="playerDeceleration" width="40"/>
											<InputText id="test1" width="40"/>
											<InputText id="test2" width="40"/>
											<PushButton id="boundingBox" label="Bounding Box" width="65"/>
										</VBox>
									</HBox>
								</Panel>
							</Window>
						</comps>;
             
            debugConfig = new MinimalConfigurator(FlxG.stage, this);
            debugConfig.parseXML(xml);
			
			setInitialValues();
			
			debugConfig.getCompById("boundingBox").addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				FlxG.visualDebug = !FlxG.visualDebug;
			});
			
			FlxG.mouse.show();
			
			return debugConfig;
		}
		
		private function setInitialValues() : void
		{
			(debugConfig.getCompById("playerMaxVelocity") as InputText).text = player.maxVelocity.x.toString();
			(debugConfig.getCompById("playerMaxVelocity") as InputText).restrict = "0123456789";
			(debugConfig.getCompById("playerDeceleration") as InputText).text = player.drag.x.toString();
			(debugConfig.getCompById("playerDeceleration") as InputText).restrict = "0123456789";
		}
		
		public function onClick(event:MouseEvent):void
		{
			player.maxVelocity.x = player.maxVelocity.y = Number((debugConfig.getCompById("playerMaxVelocity") as InputText).text);
			player.drag.x = player.drag.y = Number((debugConfig.getCompById("playerDeceleration") as InputText).text);
		}
	}
}