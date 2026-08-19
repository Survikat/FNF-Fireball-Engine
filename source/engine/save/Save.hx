package engine.save;

import flixel.FlxG;

class Save {
    public static function get(option:String):Dynamic {
        return Reflect.field(FlxG.save.data, option);
    }

    public static function set(option:String, value:Dynamic) {
        try {
            Reflect.setProperty(FlxG.save.data, option, value);
        } catch (e:Dynamic) {
            FlxG.log.warn('Failed to set option $option as $value!');
        }
    }

    public static function getBool(option:String):Bool {
        if (Std.isOfType(get(option), Bool) == true)
            return cast(get(option), Bool);

        FlxG.log.warn('Failed to get option $option as bool!');
        return false;
    }

    public static function getInt(option:String):Int {
        if (Std.isOfType(get(option), Int) == true)
            return cast(get(option), Int);

        FlxG.log.warn('Failed to get option $option as integer!');
        return 0;
    }

    public static function getFloat(option:String):Float {
        if (Std.isOfType(get(option), Float) == true)
            return cast(get(option), Float);

        FlxG.log.warn('Failed to get option $option as float!');
        return 0;
    }

    public static function getString(option:String):String {
        if (Std.isOfType(get(option), String) == true)
            return cast(get(option), String);

        FlxG.log.warn('Failed to get option $option as string!');
        return null;
    }

    public static function erase():Void
        FlxG.save.erase();
    public static function flush():Void
        FlxG.save.flush();
}