package farfadox.utils.ui.gamepad.icons;

import flixel.FlxSprite;
import farfadox.utils.ui.gamepad.GamepadInstructions.DeviceActions;

class DeviceIcons extends FlxSprite
{
    public function new(x:Float, y:Float, action:DeviceActions, isGamepad:Bool, _antialiasing:Bool)
    {
        super(x, y);

        if(isGamepad)
        {
            var model:String = 'ps4';
            trace('Loading gamepad images!');
            var path:String = 'assets/images/gamepad/' + model + '/' + action + '.png';
            loadGraphic(path);
            antialiasing = _antialiasing;
            trace('Path:' + path);
        }
        else 
        {
            trace('Loading keyboard images!');
        }
    }
}