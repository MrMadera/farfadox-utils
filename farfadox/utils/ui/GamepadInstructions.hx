package farfadox.utils.ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class GamepadInstructions extends FlxSpriteGroup
{
    public var keyIcon:FlxSprite; //i'll change this for a custom class in the future
    public var instructionText:FlxText;

    public function new(x:Float, y:Float, instructionText:String, textSize)
    {
        super(x, y);

        keyIcon = new FlxSprite().makeGraphic(50, 50, 0xFFFFFFFF);
        add(keyIcon);

        instructionText = new FlxText(0, 0, 0, instructionText, textSize);
        add(instructionText);
        
        instructionText.x = keyIcon.x + keyIcon.width + 30;
    }

    public function onChangeDevice()
    {
        // code...
    }
}