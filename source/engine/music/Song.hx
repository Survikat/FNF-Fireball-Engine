package engine.music;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSort;
import haxe.Json;

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

class TimingPoint {
    public var startTime:Float;

    public var measureDuration:Float;
    public var beatDuration:Float;
    public var quarterDuration:Float;
    public var stepDuration:Float;

    public var totalMeasures:Int;
    public var totalBeats:Int;
    public var totalQuarters:Int;
    public var totalSteps:Int;

    public var bpm:Float;
    public var timeSignature:TimeSignature;

    public function new() {}
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
    
    public var bpm(get, never):Float;
    public var timeSignature(get, never):TimeSignature;

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

    private var _beatMap:Array<TimingPoint> = [];
    
    private var _measureDuration:Float;
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

    /**
     * Sets the current BPM and Time Signature and
     * defines beat and time signature changes in the song.
     * @param bpmChanges Set to null (or nothing) to remove.
     */
    public function setBeatMap(bpmChanges:Array<BPMChangeEvent>) {
        _beatMap = new Array<TimingPoint>();

        for (i in 0...bpmChanges.length) {
            var curBPMChange:BPMChangeEvent = bpmChanges[i];

            var bpmChangeEvent:TimingPoint = new TimingPoint();
            bpmChangeEvent.startTime = curBPMChange.occursAt;

            bpmChangeEvent.bpm = curBPMChange.bpm;
            bpmChangeEvent.timeSignature = new TimeSignature(
                curBPMChange.timeSignature[0],
                curBPMChange.timeSignature[1]
            );

            // Generate Durations
            bpmChangeEvent.beatDuration = 60 / curBPMChange.bpm;
            bpmChangeEvent.measureDuration = bpmChangeEvent.timeSignature.numerator * bpmChangeEvent.beatDuration;
            bpmChangeEvent.quarterDuration = bpmChangeEvent.beatDuration * (bpmChangeEvent.timeSignature.denominator / 4);
            bpmChangeEvent.stepDuration = bpmChangeEvent.quarterDuration / 4;

            // Calculate the totals at this position
            bpmChangeEvent.totalBeats = 0;
            bpmChangeEvent.totalMeasures = 0;
            bpmChangeEvent.totalQuarters = 0;
            bpmChangeEvent.totalSteps = 0;
            
            if (i > 0) {
                var prevSectionTime:Float = 0;
                for (t in 0...i) {
                    final prevBeatDuration:Float = 60 / bpmChanges[t].bpm;
                    final prevQuarterDuration:Float = prevBeatDuration * (bpmChanges[t].timeSignature[1] / 4);
                    final prevStepDuration:Float = prevQuarterDuration / 4;
                    
                    final totalBeats:Int = Std.int((bpmChanges[t].occursAt - prevSectionTime) / prevBeatDuration);

                    bpmChangeEvent.totalBeats += totalBeats;
                    bpmChangeEvent.totalMeasures += Std.int(totalBeats / bpmChanges[t].timeSignature[0]);
                    bpmChangeEvent.totalQuarters += Std.int(bpmChanges[t].occursAt / prevQuarterDuration);
                    bpmChangeEvent.totalSteps += Std.int(bpmChanges[t].occursAt / prevStepDuration);

                    prevSectionTime = bpmChanges[t].occursAt;
                }
            }

            _beatMap.push(bpmChangeEvent);
        }

        // Sort by ascending.
        _beatMap.sort((a, b) -> {
            if (a.startTime < b.startTime) return -1;
            if (a.startTime > b.startTime) return 1;

            return 0;
        });

        _bpm = _beatMap[0].bpm;
        _timeSignature = _beatMap[0].timeSignature;

        _currentTimingPoint = _beatMap[0];
        trace(_beatMap.length);
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

    private var _currentTimingPoint:TimingPoint;

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (beatChange in _beatMap) {
            if (beatChange.startTime > time)
                break;

            _currentTimingPoint = beatChange;
        }

        _bpm = _currentTimingPoint.bpm;
        _timeSignature = _currentTimingPoint.timeSignature;

        final sectionTime:Float = time - _currentTimingPoint.startTime;

        _curBeat = _currentTimingPoint.totalBeats + Std.int(
            sectionTime / _currentTimingPoint.beatDuration
        );

        _curMeasure = _currentTimingPoint.totalMeasures + Std.int(
            sectionTime / _currentTimingPoint.timeSignature.numerator
        );

        _curQuarter = _currentTimingPoint.totalQuarters + Std.int(
            sectionTime / _currentTimingPoint.quarterDuration
        );

        _curStep = _currentTimingPoint.totalSteps + Std.int(
            sectionTime / _currentTimingPoint.stepDuration
        );

        /*_curBeat = Std.int(curTime / _beatDuration);
        _curMeasure = Std.int(_curBeat / _timeSignature.numerator);
        _curQuarter = Std.int(curTime / _quarterDuration);
        _curStep = Std.int(curTime / _stepDuration);*/

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

            trace(_beatMap.indexOf(_currentTimingPoint));
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

    public function get_time():Float
    {
        return instrumental.time / 1000;
    }

    // UPDATE LATER
    public function set_time(value:Float):Float
    {
        instrumental.time = value * 1000;
        return instrumental.time;
    }

    public function get_bpm():Float
    {
        return _bpm;
    }

    public function get_timeSignature():TimeSignature
    {
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

    function get_measureDuration():Float {
        return _measureDuration;
    }
}

typedef BPMChangeEvent = {
    var occursAt:Float;
    var bpm:Float;
    var timeSignature:Array<Int>;
}