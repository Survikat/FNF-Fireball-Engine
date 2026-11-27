package;

import engine.GameManager;
import engine.Resources;
import engine.save.Save;
// import engine.util.Logger;
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
    /* GAME DATA */
    private static var _startWidth:Int = 0;
    private static var _startHeight:Int = 0;
	private static var _startFramerate:Int = 60;
    private static var _startFullscreen:Bool = false;

	/* ENGINE META */
	public static final engineName:String = "Fireball Engine";

	public static final version:String = "0.1.0";
	public static final resourceVersion:Int = 0; // Version of current asset mappings.

    public static final discordAppID:String = "1542526698166165654";

    /* IDK WHAT TO NAME THIS IT JUST FEELS WEIRD NOT BEING HERE */
    public var _game:FlxGame;

	public function new()
	{
		super();

		// Logger.init();

        #if !desktop
        calculateGameSize();
        #end

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
                        case 'fullscreen':
                            calculateGameSize();
                            _startFullscreen = true;
					}
				}
			}
		} catch (e:Dynamic) {
			trace('Failed to perform system arguments! ($e).');
		}
		#end

		final _game = new FlxGame(_startWidth, _startHeight, InitState, _startFramerate, _startFramerate, true, _startFullscreen);
        addChild(_game);

        Save.bind("saveData", "Survikat/fireballEngine");
        FlxG.autoPause = false;

        GameManager.game = _game;

        #if desktop
		api.DiscordAPI.Init(Main.discordAppID);
		#end
	}

    private function calculateGameSize():Void {
        final aspectWidth:Int = Math.floor(Capabilities.screenResolutionX / 120);
        final aspectHeight:Int = Math.floor(Capabilities.screenResolutionY / 120);
        final aspectRatio:Float = aspectWidth / aspectHeight;

        _startHeight = 720;
        _startWidth = Math.floor(720 * aspectRatio);
    }
}

final class InitState extends FlxState {
	override public function create():Void {
        if (FileSystem.isDirectory("resources") && Save.getInt("resourceVersion") == Main.resourceVersion) {
            FlxG.switchState(() -> new PlayState());
        } else {
            FlxG.switchState(() -> new SetupState());
        }
	}
}