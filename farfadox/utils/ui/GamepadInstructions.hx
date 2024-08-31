package farfadox.utils.ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

enum DeviceActions
{
    // Model: Xbox, PlayStation, Switch
    SOUTH_BUTTON; // A, cross, B
    WEST_BUTTON; // X, square, Y
    NORTH_BUTTON; // Y, triangle, X
    EAST_BUTTON; // B, circle, A

    DIRECTIONAL_PAD_UP; // Up arrow
    DIRECTIONAL_PAD_DOWN; // Down arrow
    DIRECTIONAL_PAD_LEFT; // Left arrow
    DIRECTIONAL_PAD_RIGHT; // Right arrow

    LEFT_STICK;
    RIGHT_STICK;

    LEFT_STICK_BUTTON; 
    RIGHT_STICK_BUTTON;

    LEFT_BUMPER; //LB, L1, L2
    RIGHT_BUMPER; //RB, R1, R2

    LEFT_TRIGGER; //LT, L2, L2
    RIGHT_TRIGGER; //RT, R2, R2

    START__OPTIONS; // Start or options button
    SELECT__SHARE__BACK; //Select, share of back button
    HOME;
}

class GamepadInstructions extends FlxSpriteGroup
{
    public var keyIcon:FlxSprite; //i'll change this for a custom class in the future
    public var instructionText:FlxText;

    public function new(x:Float, y:Float, instructionText:String, textSize:Int, action:DeviceActions)
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