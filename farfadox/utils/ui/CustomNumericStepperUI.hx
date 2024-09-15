package farfadox.utils.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import farfadox.utils.ui.CustomButton;

class CustomNumericStepperUI extends FlxSpriteGroup
{
    var bg:FlxSprite;
    var text:FlxText;
    public var button_plus:CustomButton;
    public var button_minus:CustomButton;

    public var maxValue:Float = 400;
    public var minValue:Float = 1;
    public var value:Float;
    public var callback:Void -> Null<Void>;

    public var stepSize:Float;

    public function new(x:Float, y:Float, _stepSize:Float, initialValue:Float)
    {
        super(x, y);

        this.scrollFactor.set();
        scrollFactor.set();

        value = initialValue;

        stepSize = _stepSize;

        bg = new FlxSprite().makeGraphic(40, 20, 0xFFFFFFFF);
        bg.scrollFactor.set();
        add(bg);

        text = new FlxText(0, 2, 0, "" + value, 16);
        text.setFormat("VCR OSD Mono", 16, FlxColor.BLACK, CENTER);
        text.scrollFactor.set();
        add(text);

        button_plus = new CustomButton(50, 0, 20, 20, 0xFF000000, '+', 16, 0xFFFFFFFF, onPressButtonPlus);
        button_plus.scrollFactor.set();
        add(button_plus);
        
        button_minus = new CustomButton(80, 0, 20, 20, 0xFF000000, '-', 16, 0xFFFFFFFF, onPressButtonMinus);
        button_minus.scrollFactor.set();
        add(button_minus);
    }

    function onPressButtonPlus():Void
    {
        if(value < maxValue)
        {
            value += stepSize;
            FlxMath.roundDecimal(value, 1);
            if(callback != null) callback();
            updateText();
        }
    }

    function onPressButtonMinus():Void
    {
        if(value > minValue)
        {
            value -= stepSize;
            FlxMath.roundDecimal(value, 1);
            if(callback != null) callback();
            updateText();
        }
    }

    public function updateText()
    {
        text.text = "" + value;
    }
}