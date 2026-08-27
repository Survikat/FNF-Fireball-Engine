package;

import engine.Logger;
import engine.save.Highscores;
import engine.save.Save;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.app.Application;
import lime.system.System;
import lime.utils.Assets;
import openfl.display.Sprite;
import states.SetupState;

class Main extends Sprite
{
	private static var startFullscreen:Bool = false;
	private static var startFramerate:Int = 60;

	/* ENGINE INFO */
	public static final engineName:String = "Friday Night Funkin' Fireball Engine";
	public static final version:String = "0.1.0";
	public static final resourceVersion:Int = 0; // Version of current asset mappings.

	public function new()
	{
		super();

		Logger.init();

		#if desktop
		try {
			final args:Array<String> = Sys.args();
			
			for (i in 0...args.length) {
				final arg:String = args[i];

				if (StringTools.startsWith(arg, "--")) {
					final fArg:String = arg.substr(2);

					switch (fArg.toLowerCase()) {
						default:
							trace('$fArg is an invalid argument!');
						case 'reset':
							InitState.shouldResetSave = true;
						case 'fullscreen':
							startFullscreen = true;
						case 'fps':
							startFramerate = Std.int(Math.min(1000, Math.max(30, Std.parseInt(args[i + 1]))));
					}
				}
			}
		} catch (e:Dynamic) {
			trace('Failed to perform system arguments! ($e).');
		}
		#end

		addChild(new FlxGame(0, 0, InitState, startFramerate, startFramerate, true, startFullscreen));
	}
}

final class InitState extends FlxState {
	public static var shouldResetSave:Bool = false;

	override public function create():Void {
		Assets.cache.enabled = true;
		FlxG.autoPause = false;

		if (shouldResetSave) {
			trace('Resetting Save Data');

			Save.erase();
			Save.flush();

			// In the event `FlxG.resetGame()` is called.
			shouldResetSave = false;
		}

		Highscores.init();

		#if desktop
		api.DiscordAPI.Init();
		#end

		if (Save.getBool("initialized") && Save.getInt("resourceVersion") == Main.resourceVersion) {
			FlxG.switchState(() -> new TestState());
		} else {
			FlxG.switchState(() -> new SetupState());
		}
	}
}