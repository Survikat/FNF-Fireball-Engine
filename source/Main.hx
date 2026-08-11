package;

import flixel.FlxG;
import flixel.FlxGame;
import game.TestState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, TestState));
        FlxG.autoPause = false; // Ew.
	}
}
