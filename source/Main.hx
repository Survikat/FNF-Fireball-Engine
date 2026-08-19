package;

import engine.save.Highscores;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		Highscores.init();
		addChild(new FlxGame(0, 0, TestState));

        flixel.FlxG.autoPause = false; // Ew.
	}
}
