package engine.music;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.util.FlxSignal.FlxTypedSignal;

class TimeSignature
{
    public var numerator:Int;
    public var denominator:Int;

    public function new(num:Int = 4, denom:Int = 4)
    {
        numerator = num;
        denominator = denom;
    }
}

typedef SongDesc = {
    var instrumentalAsset:FlxSoundAsset;
    var bpm:Float;
    var timeSignature:TimeSignature;
}

class Song extends FlxBasic
{
    public var instrumental = new FlxSound();
    public var onBeat = new FlxTypedSignal<Int -> Void>();
    public var onQuarter = new FlxTypedSignal<Int -> Void>();
    public var onStep = new FlxTypedSignal<Int -> Void>();
    
    public var time(get, set):Float;
    public var bpm(get, set):Float;
    public var timeSignature(get, set):TimeSignature;

    public var beatDuration(get, never):Float;
    public var quarterDuration(get, never):Float;
    public var stepDuration(get, never):Float;
    public var curBeat(get, never):Float;
    public var curQuarter(get, never):Float;
    public var curStep(get, never):Float;
    
    private var _bpm:Float;
    private var _timeSignature:TimeSignature;
    private var _beatDuration:Float;
    private var _quarterDuration:Float;
    private var _stepDuration:Float;
    private var _curBeat:Int = 0;
    private var _curQuarter:Int = 0;
    private var _curStep:Int = 0;
    private var _lastBeat:Int = -1;
    private var _lastQuarter:Int = -1;
    private var _lastStep:Int = -1;
    
    // todo: support whats below
    // public var opponentVoice:Null<FlxSound>;
    // public var playerVoice:Null<FlxSound>;
    // public var combinedVoice:Null<FlxSound>;

    public function new(desc:SongDesc)
    {
        super();

        if (desc == null)
        {
            FlxG.log.error("Expected descriptor, got null");
        }

        if (desc.instrumentalAsset == null)
        {
            FlxG.log.error("Expected instrumental asset, got null");
        }

        if (desc.timeSignature == null)
        {
            FlxG.log.error("Expected time signature, got null");
        }

        instrumental.load(desc.instrumentalAsset);
        FlxG.sound.list.add(instrumental);

        _bpm = desc.bpm;
        _timeSignature = desc.timeSignature;
        _updateDurations();
    }

    override public function destroy():Void
    {
        onBeat.removeAll();
        onBeat = null;

        instrumental.destroy();
        instrumental = null;

        super.destroy();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        final songTime = time;

        _curBeat = Std.int(songTime / _beatDuration);
        _curQuarter = Std.int(songTime / _quarterDuration);
        _curStep = Std.int(songTime / _stepDuration);

        if (_curBeat != _lastBeat)
        {
            _lastBeat = _curBeat;
            onBeat.dispatch(_curBeat);
        }

        if (_curQuarter != _lastQuarter)
        {
            _lastQuarter = _curQuarter;
            onQuarter.dispatch(_curQuarter);
        }

        if (_curStep != _lastStep)
        {
            _lastStep = _curStep;
            onStep.dispatch(_curStep);
        }
    }

    // todo: expand api
    public function play():Void
    {
        instrumental.play();
    }

    private function _updateDurations():Void
    {
        _beatDuration = 60 / _bpm;
        _quarterDuration = _beatDuration * (_timeSignature.denominator / 4);
        _stepDuration = _quarterDuration / 4;
    }

    public function get_time():Float
    {
        return instrumental.time / 1000;
    }

    public function set_time(newTime:Float):Float
    {
        instrumental.time = newTime * 1000;
        return instrumental.time;
    }

    public function get_bpm():Float
    {
        return _bpm;
    }

    public function set_bpm(value:Float):Float
    {
        _bpm = value;
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

    public function get_quarterDuration():Float
    {
        return _quarterDuration;
    }

    public function get_stepDuration():Float
    {
        return _stepDuration;
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