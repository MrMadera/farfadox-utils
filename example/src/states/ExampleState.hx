package states;

import farfadox.utils.ui.gamepad.GamepadInstructions;
import flixel.FlxState;

class ExampleState extends FlxState
{
    public var south_button_ps4:GamepadInstructions;

    override function create()
    {
        super.create();

        south_button_ps4 = new GamepadInstructions(50, 50, 'Jump', 30, SOUTH_BUTTON, true);
        add(south_button_ps4);
    }
}