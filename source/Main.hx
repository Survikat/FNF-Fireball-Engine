package;

import engine.Resources;
import engine.save.Highscores;
import engine.save.Save;
import engine.util.Logger;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import lime.system.System;
import lime.utils.Assets;
import openfl.display.Sprite;
import openfl.system.Capabilities;
import states.SetupState;
import states.TestState;
import states.game.PlayState;
import sys.FileSystem;

class Main extends Sprite
{
    private static var _startWidth:Int = 0;
    private static var _startHeight:Int = 0;
	private static var _startFramerate:Int = 60;

	/* ENGINE META */
	public static final engineName:String = "Fireball Engine";

	public static final version:String = "0.1.0";
	public static final resourceVersion:Int = 0; // Version of current asset mappings.

    public static final discordAppID:String = "1542526698166165654";

	public function new()
	{
		super();

		Logger.init();

        final aspectWidth:Int = Math.floor(Capabilities.screenResolutionX / 120);
        final aspectHeight:Int = Math.floor(Capabilities.screenResolutionY / 120);
        final aspectRatio:Float = aspectWidth / aspectHeight;

        _startHeight = 720;
        _startWidth = Math.floor(720 * aspectRatio);

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
                            _startWidth = Std.int(Math.max(640, Std.parseInt(args[i + 1])));
                        case 'height':
                            _startHeight = Std.int(Math.max(360, Std.parseInt(args[i + 1])));
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

        // Save.bind("saveData", "Survikat/fireballEngine");
		Highscores.init();

		#if desktop
		api.DiscordAPI.Init(Main.discordAppID);
		#end

        if (FileSystem.isDirectory("resources") && Save.getInt("resourceVersion") == Main.resourceVersion) {
            FlxG.switchState(() -> new PlayState());
        } else {
            FlxG.switchState(() -> new SetupState());
        }
	}
}