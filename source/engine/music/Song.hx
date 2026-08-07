package engine.music;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.util.FlxSignal.FlxTypedSignal;

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

class Song extends FlxBasic
{
    public var instrumental:FlxSound;

    public var onMeasure:FlxTypedSignal<Int->Void>;
    public var onBeat:FlxTypedSignal<Int->Void>;
    public var onQuarter:FlxTypedSignal<Int->Void>;
    public var onStep:FlxTypedSignal<Int->Void>;
    
    /**
     * Time in seconds
     */
    public var time(get, set):Float;
    
    public var bpm(get, set):Float;
    public var timeSignature(get, set):TimeSignature;

    public var measureDuration(get, never):Float;
    public var beatDuration(get, never):Float;
    public var quarterDuration(get, never):Float;
    public var stepDuration(get, never):Float;
    public var curMeasure(get, never):Float;
    public var curBeat(get, never):Float;
    public var curQuarter(get, never):Float;
    public var curStep(get, never):Float;
    
    private var _bpm:Float;
    private var _timeSignature:TimeSignature;
    private var _beatDuration:Float;
    private var _quarterDuration:Float;
    private var _stepDuration:Float;
    private var _curMeasure:Int;
    private var _curBeat:Int;
    private var _curQuarter:Int;
    private var _curStep:Int;
    private var _lastMeasure:Int;
    private var _lastBeat:Int;
    private var _lastQuarter:Int;
    private var _lastStep:Int;
    
    // todo: support whats below
    // public var opponentVoice:Null<FlxSound>;
    // public var playerVoice:Null<FlxSound>;
    // public var combinedVoice:Null<FlxSound>;

    public function new()
    {
        super();
        
        instrumental = new FlxSound();
        FlxG.sound.list.add(instrumental);
        // add voices to the list too

        onMeasure = new FlxTypedSignal<Int->Void>();
        onBeat = new FlxTypedSignal<Int->Void>();
        onQuarter = new FlxTypedSignal<Int->Void>();
        onStep = new FlxTypedSignal<Int->Void>();

        _bpm = 0;
        _timeSignature = new TimeSignature(1, 1);
        
        _beatDuration = 0;
        _quarterDuration = 0;
        _stepDuration = 0;
        
        _curMeasure = 0;
        _curBeat = 0;
        _curQuarter = 0;
        _curStep = 0;

        _lastMeasure = -1;
        _lastBeat = -1;
        _lastQuarter = -1;
        _lastStep = -1;
    }

    override public function destroy():Void
    {
        onMeasure.removeAll();
        onMeasure = null;
        
        onBeat.removeAll();
        onBeat = null;

        onQuarter.removeAll();
        onQuarter = null;

        onStep.removeAll();
        onStep = null;

        instrumental.destroy();
        instrumental = null;

        super.destroy();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (_bpm == 0)
        {
            return;
        }

        final curTime:Float = time;

        _curBeat = Std.int(curTime / _beatDuration);
        _curMeasure = Std.int(_curBeat / _timeSignature.numerator);
        _curQuarter = Std.int(curTime / _quarterDuration);
        _curStep = Std.int(curTime / _stepDuration);

        if (_curStep != _lastStep)
        {
            _lastStep = _curStep;
            onStep.dispatch(_curStep);
        }

        if (_curQuarter != _lastQuarter)
        {
            _lastQuarter = _curQuarter;
            onQuarter.dispatch(_curQuarter);
        }

        if (_curBeat != _lastBeat)
        {
            _lastBeat = _curBeat;
            onBeat.dispatch(_curBeat);
        }

        if (_curMeasure != _lastMeasure)
        {
            _lastMeasure = _curMeasure;
            onMeasure.dispatch(_curMeasure);
        }
    }

    // todo: expand api (add more functions)
    public function play():Void
    {
        instrumental.play();
        // play voices
    }

    private function _updateDurations():Void
    {
        if (_bpm == 0)
        {
            _beatDuration = 0;
            _quarterDuration = 0;
            _stepDuration = 0;
            return;
        }

        _beatDuration = 60 / _bpm;
        _quarterDuration = _beatDuration * (_timeSignature.denominator / 4);
        _stepDuration = _quarterDuration / 4;
    }

    public function get_time():Float
    {
        return instrumental.time / 1000;
    }

    public function set_time(value:Float):Float
    {
        instrumental.time = value * 1000;
        return instrumental.time;
    }

    public function get_bpm():Float
    {
        return _bpm;
    }

    public function set_bpm(value:Float):Float
    {
        _bpm = Math.max(value, 0);
        _updateDurations();
        return _bpm;
    }

    public function get_timeSignature():TimeSignature
    {
        return _timeSignature;
    }

    public function set_timeSignature(value:TimeSignature):TimeSignature
    {
        _timeSignature = value;
        _updateDurations();
        return _timeSignature;
    }

    public function get_beatDuration():Float
    {
        return _beatDuration;
    }

    public function get_measureDuration():Float
    {
        return (_bpm > 0) ? _timeSignature.numerator * _beatDuration : 0;
    }

    public function get_quarterDuration():Float
    {
        return _quarterDuration;
    }

    public function get_stepDuration():Float
    {
        return _stepDuration;
    }

    public function get_curMeasure():Float
    {
        return _curMeasure;
    }

    public function get_curBeat():Float
    {
        return _curBeat;
    }

    public function get_curQuarter():Float
    {
        return _curQuarter;
    }

    public function get_curStep():Float
    {
        return _curStep;
    }
}