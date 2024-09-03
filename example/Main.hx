package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.ExampleState;

class Main extends Sprite {
	public function new() {
		super();
		FlxG.autoPause = false;
		addChild(new FlxGame(1920, 1080, ExampleState, true));
	}
}