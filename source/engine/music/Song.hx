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

    public var canonicalBars(get, never):Int;
    public var canonicalBeats(get, never):Int;
    public var canonicalQuarters(get, never):Int;
    public var canonicalSteps(get, never):Int;

    public var elapsedBars(get, never):Int;
    public var elapsedBeats(get, never):Int;
    public var elapsedQuarters(get, never):Int;
    public var elapsedSteps(get, never):Int;

    public var barMeasure(get, never):Float;
    public var beatMeasure(get, never):Float;
    public var quarterMeasure(get, never):Float;
    public var stepMeasure(get, never):Float;
    
    private var _bpm:Float                   = 0.0;
    private var _timeSignature:TimeSignature = new TimeSignature(1, 1);
    private var _measures:MusicMeasures      = {}

    private var _bars:Reactive<Int>;
    private var _beats:Reactive<Int>;
    private var _quarters:Reactive<Int>;
    private var _steps:Reactive<Int>;

    private var _baseBars:Int     = 0;
    private var _baseBeats:Int    = 0;
    private var _baseQuarters:Int = 0;
    private var _baseSteps:Int    = 0;

    private var _lastEventTime:Float = 0.0;
    
    private var _events:Null<Array<JSONSongEvent>> = null;
    private var _eventIndex:Null<Int>              = null;
    
    public function new()
    {
        super();

        _bars     = new Reactive<Int>(0, onBar.dispatch);
        _beats    = new Reactive<Int>(0, onBeat.dispatch);
        _quarters = new Reactive<Int>(0, onQuarter.dispatch);
        _steps    = new Reactive<Int>(0, onStep.dispatch);
        
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
        final eventsActive:Bool = _eventIndex != null && _events != null;
        
        while (eventsActive &&
               _eventIndex < _events.length &&
               t >= _events[_eventIndex].timestamp)
        {
            final event = _events[_eventIndex];

            // from _lastEventTime to current event's timestamp
            final dt = event.timestamp - _lastEventTime;

            if (dt > 0 && _bpm > 0)
            {
                _baseBars     += Std.int(dt / _measures.bar);
                _baseBeats    += Std.int(dt / _measures.beat);
                _baseQuarters += Std.int(dt / _measures.quarter);
                _baseSteps    += Std.int(dt / _measures.step);
            }
            
            _lastEventTime = event.timestamp;
            _bpm           = event.bpm;
            _timeSignature = new TimeSignature(event.timeSignature[0], event.timeSignature[1]);
            _updateMeasures();

            _eventIndex++;
        }

        // from _lastEventTime to now
        final dt = t - _lastEventTime;

        if (dt > 0 && _bpm > 0)
        {
            _bars.value     = _baseBars     + Std.int(dt / _measures.bar);
            _beats.value    = _baseBeats    + Std.int(dt / _measures.beat);
            _quarters.value = _baseQuarters + Std.int(dt / _measures.quarter);
            _steps.value    = _baseSteps    + Std.int(dt / _measures.step);
        }
        else
        {
            _bars.value     = _baseBars;
            _beats.value    = _baseBeats;
            _quarters.value = _baseQuarters;
            _steps.value    = _baseSteps;
        }
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

    private function get_canonicalBars():Int
    {
        return _bars.value;
    }

    private function get_canonicalBeats():Int
    {
        return _beats.value;
    }

    private function get_canonicalQuarters():Int
    {
        return _quarters.value;
    }

    private function get_canonicalSteps():Int
    {
        return _steps.value;
    }

    private function get_elapsedBars():Int
    {
        return _bars.changeCount;
    }

    private function get_elapsedBeats():Int
    {
        return _beats.changeCount;
    }

    private function get_elapsedQuarters():Int
    {
        return _quarters.changeCount;
    }

    private function get_elapsedSteps():Int
    {
        return _steps.changeCount;
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