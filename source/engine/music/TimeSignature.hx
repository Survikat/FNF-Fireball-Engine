package engine.music;

class TimeSignature
{
    public var numerator(get, set):Int;
    public var denominator(get, set):Int;

    private var _numerator:Int;
    private var _denominator:Int;

    public function new(a:Int, b:Int)
    {
        numerator = a;
        denominator = b;
    }

    public function get_numerator():Int
    {
        return _numerator;
    }

    public function set_numerator(value:Int):Int
    {
        _numerator = Std.int(Math.max(value, 1));
        return _numerator;
    }

    public function get_denominator():Int
    {
        return _denominator;
    }

    public function set_denominator(value:Int):Int
    {
        _denominator = Std.int(Math.max(value, 1));
        return _denominator;
    }
}