package engine.music;

import engine.music.TimeSignature;
import engine.util.Reactive;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * Stores music measures (bar, beat, quarter, and step) in seconds.
 */
@:structInit
@:publicFields
class MusicMeasures
{
    var bar:Float     = 0.0;
    var beat:Float    = 0.0;
    var quarter:Float = 0.0;
    var step:Float    = 0.0;
}

typedef JSONSongEvent = {
    var timestamp:Float;
    var bpm:Float;
    var timeSignature:Array<Int>;
}

class Song extends FlxBasic
{
    public var instrumental:FlxSound = new FlxSound();
    // TODO VOICES

    public var onBar:FlxTypedSignal<(Int, Int) -> Void>     = new FlxTypedSignal<(Int, Int) -> Void>();
    public var onBeat:FlxTypedSignal<(Int, Int) -> Void>    = new FlxTypedSignal<(Int, Int) -> Void>();
    public var onQuarter:FlxTypedSignal<(Int, Int) -> Void> = new FlxTypedSignal<(Int, Int) -> Void>();
    public var onStep:FlxTypedSignal<(Int, Int) -> Void>    = new FlxTypedSignal<(Int, Int) -> Void>();
    
    /**
     * Time in seconds.
     */
    public var time(get, never):Float;

    public var bpm(get, set):Float;
    public var timeSignature(get, set):TimeSignature;

    public var bar(get, never):Int;
    public var beat(get, never):Int;
    public var quarter(get, never):Int;
    public var step(get, never):Int;

    public var barMeasure(get, never):Float;
    public var beatMeasure(get, never):Float;
    public var quarterMeasure(get, never):Float;
    public var stepMeasure(get, never):Float;
    
    private var _bpm:Float                   = 0.0;
    private var _timeSignature:TimeSignature = new TimeSignature(1, 1);
    private var _measures:MusicMeasures      = {}

    private var _bar:Reactive<Int>;
    private var _beat:Reactive<Int>;
    private var _quarter:Reactive<Int>;
    private var _step:Reactive<Int>;

    private var _elapsedBar:Float     = 0.0;
    private var _elapsedBeat:Float    = 0.0;
    private var _elapsedQuarter:Float = 0.0;
    private var _elapsedStep:Float    = 0.0;

    private var _events:Null<Array<JSONSongEvent>> = null;
    private var _eventIndex:Null<Int>              = null;

    private var _lastEventTime:Float = 0.0;
    
    public function new()
    {
        super();

        _bar     = new Reactive<Int>(0, onBar.dispatch);
        _beat    = new Reactive<Int>(0, onBeat.dispatch);
        _quarter = new Reactive<Int>(0, onQuarter.dispatch);
        _step    = new Reactive<Int>(0, onStep.dispatch);
        
        FlxG.sound.list.add(instrumental);
    }

    public function setEvents(events:Array<JSONSongEvent>) {
        if (events == null)
        {
            FlxG.log.error("Expected events, got null");
        }

        _events = events;

        // Sort by ascending.
        _events.sort((a:JSONSongEvent, b:JSONSongEvent) -> {
            if (a.timestamp < b.timestamp)
            {
                return -1;
            }
            if (a.timestamp > b.timestamp)
            {
                return 1;
            }
            return 0;
        });

        // Reset index
        _eventIndex = 0;
    }

    public function clearEvents():Void
    {
        if (_events != null)
        {
            _events.resize(0);
            _events = null;
        }

        _eventIndex = null;
    }

    override public function destroy():Void
    {
        onBar.removeAll();
        onBeat.removeAll();
        onQuarter.removeAll();
        onStep.removeAll();
        
        instrumental.destroy();
        
        onBar = null;
        onBeat = null;
        onQuarter = null;
        onStep = null;

        instrumental = null;

        super.destroy();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        final t:Float = time;

        if (_eventIndex != null && _events != null)
        {
            while (_eventIndex < _events.length && t >= _events[_eventIndex].timestamp)
            {
                final event:JSONSongEvent = _events[_eventIndex];

                _advanceTo(event.timestamp);

                _bpm = event.bpm;
                _timeSignature = new TimeSignature(event.timeSignature[0], event.timeSignature[1]);
                _updateMeasures();

                _lastEventTime = event.timestamp;
                ++_eventIndex;
            }
        }

        _advanceTo(t);
    }

    // EXPAND API LATER
    public function play():Void
    {
        instrumental.play();
    }

    private function _updateMeasures():Void
    {
        if (_bpm == 0)
        {
            _measures = {}
            return;
        }

        _measures.beat = 60.0 / _bpm;
        _measures.bar = _timeSignature.numerator * _measures.beat;
        _measures.quarter = _measures.beat * (_timeSignature.denominator / 4);
        _measures.step = _measures.quarter / 4.0;
    }

    private function _advanceTo(t:Float):Void
    {
        final dt:Float = t - _lastEventTime;

        if (dt <= 0.0 || _bpm <= 0.0)
        {
            return;
        }

        _elapsedBar     += dt / _measures.bar;
        _elapsedBeat    += dt / _measures.beat;
        _elapsedQuarter += dt / _measures.quarter;
        _elapsedStep    += dt / _measures.step;

        _lastEventTime = t;

        _bar.value     = Std.int(_elapsedBar);
        _beat.value    = Std.int(_elapsedBeat);
        _quarter.value = Std.int(_elapsedQuarter);
        _step.value    = Std.int(_elapsedStep);
    }

    private function get_time():Float
    {
        return instrumental.time / 1000.0;
    }

    private function get_bpm():Float
    {
        return _bpm;
    }

    private function set_bpm(v:Float):Float
    {
        _bpm = Math.max(v, 0.0);
        _updateMeasures();
        return _bpm;
    }

    private function get_timeSignature():TimeSignature
    {
        return _timeSignature;
    }

    private function set_timeSignature(v:TimeSignature):TimeSignature
    {
        _timeSignature = v;
        _updateMeasures();
        return _timeSignature;
    }

    private function get_bar():Int
    {
        return _bar.value;
    }

    private function get_beat():Int
    {
        return _beat.value;
    }

    private function get_quarter():Int
    {
        return _quarter.value;
    }

    private function get_step():Int
    {
        return _step.value;
    }

    private function get_barMeasure():Float
    {
        return _measures.bar;
    }

    private function get_beatMeasure():Float
    {
        return _measures.beat;
    }

    private function get_quarterMeasure():Float
    {
        return _measures.quarter;
    }

    private function get_stepMeasure():Float
    {
        return _measures.step;
    }
}