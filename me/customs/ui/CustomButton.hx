package customs.ui;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;

class CustomButton extends FlxSpriteGroup
{
    public var bgSelectedColor:FlxColor = 0xFFFFFFFF;
    public var txtSelectedColor:FlxColor = 0xFF000000;
    public var bgColor:FlxColor;
    public var txtColor:FlxColor;
    public var bgWidth:Int;
    public var bgHeight:Int;
    public var onPress:Void -> Void;
    public var bg:FlxSprite;
    public var txt:FlxText;

    // Optional stuff
    public var usingSounds:Bool = false;
    public var selectButtonSound:String = '';
    public var pressButtonSound:String = '';

    public function new(x:Float, y:Float, width:Int, height:Int, _bgColor:FlxColor, text:String, size:Int, _txtColor:FlxColor, _onPress:Void -> Void)
    {
        bgColor = _bgColor;
        txtColor = _txtColor;
        bgWidth = width;
        bgHeight = height;
        onPress = _onPress;

        super(x, y);

        bg = new FlxSprite().makeGraphic(width, height, _bgColor);
        add(bg);

        txt = new FlxText(0, 0, bg.width, text, size);
        txt.setFormat("VCR OSD Mono", size, txtColor, CENTER);
        txt.y = (bg.height / 2) - (txt.height / 2);
        txt.antialiasing = ClientPrefs.data.antialiasing;
        add(txt);
    }
    
    var soundPlayed:Bool = false;

    override function update(elapsed:Float)
    {
        if(FlxG.mouse.overlaps(this))
        {
            if(!soundPlayed && usingSounds)
            {
                if(selectButtonSound != '')  FlxG.sound.play(Paths.sound(selectButtonSound));
                soundPlayed = true;
            }
            bg.makeGraphic(bgWidth, bgHeight, bgSelectedColor);
            txt.color = txtSelectedColor;
            if(FlxG.mouse.justPressed)
            {
                onPress();
                if(pressButtonSound != '' && usingSounds) FlxG.sound.play(Paths.sound(pressButtonSound));
            }
        }
        else
        {
            bg.makeGraphic(bgWidth, bgHeight, bgColor);
            txt.color = txtColor;
            soundPlayed = false;
        }
        super.update(elapsed);
    }
}