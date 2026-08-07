package;

import flixel.FlxGame;
import game.SetupState;
import game.TestState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, TestState));
	}
}
