package engine.util;

import flixel.FlxG;

typedef ReactiveArgs<T> = {
    var initialValue:T;
    var callback:T -> Void;
}

final class Reactive<T> {
    public var value(get, set):T;

    private var _value:T;
    private var _callback:T -> Void;

    public function new(args:ReactiveArgs<T>) {
        if (args.callback == null) {
            FlxG.log.error("Expected callback, got null");
        }
        _value = args.initialValue;
        _callback = args.callback;
    }

    private function get_value():T {
        return _value;
    }

    private function set_value(val:T):T {
        if (val != _value) {
            _value = val;
            if (_callback != null) {
                _callback(val);
            }
        }
        return _value;
    }
}