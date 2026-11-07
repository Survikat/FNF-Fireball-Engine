package engine.save;

import flixel.FlxG;
import flixel.util.FlxSave;
import lime.system.System;

final class Save {
    public static function bind(name:String, ?path:String):Void {
        FlxG.save.bind(name, path);
    }

    public static function get(option:String):Dynamic {
        final iterators:Array<String> = option.split(".");
        var curReference:Dynamic = FlxG.save.data;

        try {
            for (opt in iterators) {
                curReference = Reflect.field(curReference, opt);
            }
        } catch (e:Dynamic) {
            FlxG.log.warn('Failed to obtain value of "$option" ($e).');
            return null;
        }

        return curReference;
    }

    public static function set(option:String, value:Dynamic) {
        try {
            final iterators:Array<String> = option.split(".");
            var curReference:Dynamic = FlxG.save.data;

            for (i in 0...iterators.length - 1) {
                curReference = Reflect.field(curReference, iterators[i]);
            }

            Reflect.setField(curReference, iterators[iterators.length - 1], value);
        } catch (e:Dynamic) {
            FlxG.log.warn('Failed to set option $option as $value!');
        }

        flush();
    }

    public static function getBool(option:String):Bool {
        if (Std.isOfType(get(option), Bool) == true)
            return cast(get(option), Bool);

        return false;
    }

    public static function getInt(option:String):Int {
        if (Std.isOfType(get(option), Int) == true)
            return cast(get(option), Int);

        return 0;
    }

    public static function getFloat(option:String):Float {
        if (Std.isOfType(get(option), Float) == true)
            return cast(get(option), Float);

        return 0;
    }

    public static function getString(option:String):String {
        if (Std.isOfType(get(option), String) == true)
            return cast(get(option), String);

        return null;
    }

    public static function erase():Void
        FlxG.save.erase();
    public static function flush():Void
        FlxG.save.flush();
}