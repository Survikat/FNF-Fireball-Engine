package;

import engine.save.Highscores;
import engine.save.Save;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.app.Application;
import lime.system.System;
import openfl.display.Sprite;
import states.SetupState;

class Main extends Sprite
{
	public function new()
	{
		super();

		Highscores.init();
		addChild(new FlxGame(0, 0, InitState));

        flixel.FlxG.autoPause = false; // Ew.
	}
}

class InitState extends FlxState {
	override public function create():Void {
		#if desktop
		api.DiscordAPI.Init();
		#end

		if (!Save.getBool("initialized")) {
			FlxG.switchState(() -> new SetupState());
		} else {
			FlxG.switchState(() -> new TestState());
		}
	}
}