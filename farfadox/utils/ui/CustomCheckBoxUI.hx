package farfadox.utils.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.FlxObject;

class CustomCheckBoxUI extends FlxSpriteGroup
{
    var checkBox:FlxSprite;
    public var checkSign:FlxSprite;
    var text:FlxText;

    public var checked:Bool;
    public var callback:Void -> Null<Void>;
    
    public var getLastCamera:Bool = false;

    public function new(x:Float, y:Float, width:Int = 20, height:Int = 20, label:String, size:Int)
    {
        super(x, y);

        checkBox = new FlxSprite().makeGraphic(width, height, 0xFFFFFFFF);
        add(checkBox);

        checkSign = new FlxSprite().loadGraphic('assets/images/check_mark.png');
        checkSign.setGraphicSize(width, height);
        add(checkSign);

        text = new FlxText(25, 2, 0, label, size);
		text.setFormat("VCR OSD Mono", size, FlxColor.WHITE, LEFT);
        add(text);

        //centerOnSprite(text, checkBox, false, true);
    }

    public override function update(elapsed:Float)
    {
        super.update(elapsed);

        var hudMousePos = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1]);
        if(getLastCamera)
        {
            if(this.overlapsPoint(hudMousePos))
            {
                if(FlxG.mouse.justPressed)
                {
                    clickCheck();
                }
            }
        }
        else
        {
            if(FlxG.mouse.overlaps(this))
            {
                if(FlxG.mouse.justPressed)
                {
                    clickCheck();
                }
            }
        }
    }

    public function clickCheck()
    {
        checked = !checked;
        trace('CHECKED: ' + checked);

        checkSign.visible = checked;
        if(callback != null) callback();
    }

    public function updateCheck()
    {
        checkSign.visible = checked;
        if(callback != null) callback();
    }
}