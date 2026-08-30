package;

import engine.Logger;
import engine.Resources;
import engine.save.Highscores;
import engine.save.Save;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.utils.Assets;
import openfl.display.Sprite;
import states.SetupState;
import states.TestState;
import sys.FileSystem;

class Main extends Sprite
{
    private static var _startWidth:Int = 0;
    private static var _startHeight:Int = 0;
	private static var _startFramerate:Int = 60;

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
						case 'fps':
							_startFramerate = Std.int(Math.min(1000, Math.max(30, Std.parseInt(args[i + 1]))));
                        case 'width':
                            _startWidth = Std.int(Math.max(1280, Std.parseInt(args[i + 1])));
                        case 'height':
                            _startHeight = Std.int(Math.max(720, Std.parseInt(args[i + 1])));
					}
				}
			}
		} catch (e:Dynamic) {
			trace('Failed to perform system arguments! ($e).');
		}
		#end

		addChild(new FlxGame(_startWidth, _startHeight, InitState, _startFramerate, _startFramerate, true));
	}
}

final class InitState extends FlxState {
	override public function create():Void {
		Assets.cache.enabled = true;
		FlxG.autoPause = false;

		Highscores.init();

		#if desktop
		api.DiscordAPI.Init();
		#end

		if (FileSystem.isDirectory("resources") && Save.getInt("resourceVersion") == Main.resourceVersion) {
			FlxG.switchState(() -> new TestState());
		} else {
			FlxG.switchState(() -> new SetupState());
		}
	}
}