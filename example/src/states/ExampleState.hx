package states;

import farfadox.utils.ui.gamepad.GamepadInstructions;
import flixel.FlxState;

class ExampleState extends FlxState
{
    public var south_button_ps4:GamepadInstructions;
    public var west_button_ps4:GamepadInstructions;
    public var east_button_ps4:GamepadInstructions;
    public var north_button_ps4:GamepadInstructions;

    override function create()
    {
        super.create();

        south_button_ps4 = new GamepadInstructions(50, 50, 'Jump', 30, SOUTH_BUTTON, true, true);
        add(south_button_ps4);
        
        west_button_ps4 = new GamepadInstructions(50, 100, 'Interact', 30, WEST_BUTTON, true, true);
        add(west_button_ps4);
        
        east_button_ps4 = new GamepadInstructions(50, 150, 'Back', 30, EAST_BUTTON, true, true);
        add(east_button_ps4);
        
        north_button_ps4 = new GamepadInstructions(50, 200, 'Talk', 30, NORTH_BUTTON, true, true);
        add(north_button_ps4);
    }
}