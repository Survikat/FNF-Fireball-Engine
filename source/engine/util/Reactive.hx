package engine.util;

import flixel.FlxG;

class Reactive<T>
{
    public var value(get, set):T;
    public var changeCount(get, never):Int;
    public final onChange:(T, Int) -> Void;
    
    private var _value:T;
    private var _changeCount:Int = 0;

    public function new(v:T, callback:(T, Int) -> Void)
    {
        if (callback == null)
        {
            FlxG.log.error("Expected callback, got null");
        }

        _value = v;
        onChange = callback;
    }

    private function get_value():T
    {
        return _value;
    }

    private function set_value(v:T):T
    {
        if (_value != v)
        {
            onChange(_value = v, ++_changeCount);
        }

        return _value;
    }

    private function get_changeCount():Int
    {
        return _changeCount;
    }
}