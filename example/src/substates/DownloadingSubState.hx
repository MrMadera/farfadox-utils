package example.src.substates;

import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxG;

class DownloadingSubState extends FlxSubState
{
    public function new() 
    {
        super();
        
        var bg:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, 0xFF000000);
        add(bg);

        var downloadStatus:FlxText;
        var downloadBytesStatus:FlxText;
        var processBar:FlxBar;
    }
}