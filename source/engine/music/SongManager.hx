package engine.music;

import engine.Reactive;
import engine.music.SongMetaData;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.sound.FlxSoundGroup;
import flixel.util.FlxSignal.FlxTypedSignal;
import flixel.util.FlxSort;
import haxe.Json;

class TimeSignature {
    public var numerator(get, set):Int;
    public var denominator(get, set):Int;

    private var _numerator:Int;
    private var _denominator:Int;

    public function new(a:Int, b:Int) {
        numerator = a;
        denominator = b;
    }

    public function get_numerator():Int {
        return _numerator;
    }

    public function set_numerator(value:Int):Int {
        _numerator = Std.int(Math.max(value, 1));
        return _numerator;
    }

    public function get_denominator():Int {
        return _denominator;
    }

    public function set_denominator(value:Int):Int {
        _denominator = Std.int(Math.max(value, 1));
        return _denominator;
    }
}

class TimingPoint {
    public var startTime:Float;

    public var beatDuration:Float;
    public var prevBeats:Float;

    public var barDuration:Float;
    public var prevBars:Float;

    public var bpm:Float;
    public var timeSignature:TimeSignature;

    public function new() {}
}

class SongManager extends FlxBasic {
    private var _tracks:FlxSoundGroup;

    public var onBar:FlxTypedSignal<Int->Void>;
    public var onBeat:FlxTypedSignal<Int->Void>;
    public var onStep:FlxTypedSignal<Int->Void>;
    
    /**
     * Time in seconds
     */
    public var time(get, set):Float;
    public var pitch(get, set):Float;

    public var looped(get, set):Bool;
    public var playing(get, never):Bool;

    public var volume:Float = 1.0;
    
    public var bpm(get, never):Float;
    public var timeSignature(get, never):TimeSignature;

    public var beatMap(get, never):Array<TimingPoint>;

    public var beatDuration(get, never):Float;
    public var barDuration(get, never):Float;

    public var curBar(get, never):Int;
    public var curBeat(get, never):Int;
    public var curStep(get, never):Int;

    private var _playing:Bool = false;
    
    private var _bpm:Float;
    private var _timeSignature:TimeSignature;

    private var _beatMap:Array<TimingPoint> = [];
    
    private var _beatDuration:Float;
    private var _barDuration:Float;
    
    private var _curBar:Reactive<Int>;
    private var _curBeat:Reactive<Int>;
    private var _curStep:Reactive<Int>;

    public function new() {
        super();

        _tracks = new FlxSoundGroup();

        onBar = new FlxTypedSignal<Int->Void>();
        onBeat = new FlxTypedSignal<Int->Void>();
        onStep = new FlxTypedSignal<Int->Void>();

        _bpm = 0;
        _timeSignature = new TimeSignature(1, 1);
        
        _beatDuration = 0;
        
        _curBar = new Reactive<Int>({
            initialValue: 0,
            callback: onBar.dispatch
        });

        _curBeat = new Reactive<Int>({
            initialValue: 0,
            callback: onBeat.dispatch
        });

        _curStep = new Reactive<Int>({
            initialValue: 0,
            callback: onStep.dispatch
        });
    }

    /**
     * Defines beat and time signature changes in the song.
     * This is also used to set the BPM in the song.
     * @param bpmChanges
     */
    public function setBeatMap(bpmChanges:Array<BPMChangeEvent>) {
        bpmChanges.sort((a, b) -> { // Sort by ascending.
            if (a.occursAt < b.occursAt) return -1;
            if (a.occursAt > b.occursAt) return 1;

            return 0;
        });

        _beatMap = [];

        for (i in 0...bpmChanges.length) {
            var curBPMChange:BPMChangeEvent = bpmChanges[i];

            var bpmChangeEvent:TimingPoint = new TimingPoint();
            bpmChangeEvent.startTime = curBPMChange.occursAt;

            bpmChangeEvent.bpm = curBPMChange.bpm;
            bpmChangeEvent.timeSignature = new TimeSignature(
                curBPMChange.timeSignature[0],
                curBPMChange.timeSignature[1]
            );

            bpmChangeEvent.beatDuration = 60 / bpmChangeEvent.bpm;
            bpmChangeEvent.prevBeats = 0;

            bpmChangeEvent.barDuration = bpmChangeEvent.beatDuration * bpmChangeEvent.timeSignature.numerator;
            bpmChangeEvent.prevBars = 0;

            if (i > 0) {
                final prevBeatChange:TimingPoint = _beatMap[i - 1];
                final sectionTime:Float = bpmChangeEvent.startTime - prevBeatChange.startTime;

                bpmChangeEvent.prevBeats = prevBeatChange.prevBeats + (sectionTime / prevBeatChange.beatDuration);
                bpmChangeEvent.prevBars = prevBeatChange.prevBars + (sectionTime / prevBeatChange.barDuration);
            }

            _beatMap.push(bpmChangeEvent);
        }

        _bpm = _beatMap[0].bpm;
        _timeSignature = _beatMap[0].timeSignature;

        _currentTimingPoint = _beatMap[0];
    }

    override public function destroy():Void {
        onBar.removeAll();
        onBar = null;
        
        onBeat.removeAll();
        onBeat = null;

        onStep.removeAll();
        onStep = null;

        for (track in _tracks.sounds){
            track.stop();

            track.kill();
            track.destroy();
        }

        super.destroy();
    }

    public var currentTimingPoint(get, never):TimingPoint;
    private var _currentTimingPoint:TimingPoint;

    private var _lastTimingIndex:Int = 0;

    override public function update(elapsed:Float):Void {
        if (_tracks.sounds.length > 0) {
            _tracks.volume = volume;

            final mainTrack:FlxSound = _tracks.sounds[0];
            mainTrack.update(elapsed);

            for (i in 1..._tracks.sounds.length) {
                final track:FlxSound = _tracks.sounds[i];

                track.pitch = mainTrack.pitch;
                track.looped = mainTrack.looped;

                if (!track.playing && _playing)
                    track.play();
                else if (track.playing && !_playing)
                    track.pause();

                track.update(elapsed);

                if (Math.abs(track.time - mainTrack.time) > 20) {
                    // trace('Track is unsynced! Should be ${mainTrack.time / 1000} but is ${track.time / 1000}. Offset by ${Math.abs(track.time - mainTrack.time) / 1000}.');

                    track.time = mainTrack.time;
                }
            }
        }

        super.update(elapsed);

        // Updates the current timing point, then sets the last timing point to the current index.
        _lastTimingIndex = updateTimingPoint(_lastTimingIndex);

        _bpm = _currentTimingPoint.bpm;
        _timeSignature = _currentTimingPoint.timeSignature;

        _beatDuration = _currentTimingPoint.beatDuration;
        _barDuration = _currentTimingPoint.barDuration;

        final sectionTime:Float = time - _currentTimingPoint.startTime;

        _curBeat.value = Math.floor(_currentTimingPoint.prevBeats + (sectionTime / _beatDuration));
        _curStep.value = Math.floor((_currentTimingPoint.prevBeats * 4) + (sectionTime / (_beatDuration / 4)));
        _curBar.value = Math.floor(_currentTimingPoint.prevBars + (sectionTime / _barDuration));
    }

    /**
     * Updates the current timing point (beat change).
     * @param startIndex Where it should start from in the check
     * @return Index of the current timing point.
     */
    private function updateTimingPoint(startIndex:Int = 0):Int {
        var currentIndex:Int = 0;
        final start:Int = Std.int(Math.max(Math.min(startIndex, _beatMap.length), 0));

        for (i in start..._beatMap.length) {
            if (_beatMap[i].startTime > time)
                break;

            _currentTimingPoint = _beatMap[i];
            currentIndex = i;
        }

        return currentIndex;
    }

    public function addTrack(track:FlxSound) {
        _tracks.add(track);
    }

    public function removeTrack(track:FlxSound) {
        track.stop();
        track.kill();

        _tracks.remove(track);
    }

    private function get_playing():Bool
        return _playing;

    public function play():Void {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        _playing = true;

        for (track in _tracks.sounds)
            track.play();
    }

    public function pause():Void {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        _playing = false;

        for (track in _tracks.sounds)
            track.pause();
    }

    public function clear():Void {
        _playing = false;

        for (track in _tracks.sounds){
            track.stop();

            track.kill();
            track.destroy();
        }

        _tracks.sounds = [];
        _beatMap = [];
        _lastTimingIndex = 0;
    }

    private function get_time():Float {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        return _tracks.sounds[0].time / 1000;
    }

    private function set_time(value:Float):Float {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        _lastTimingIndex = 0;

        for (track in _tracks.sounds) {
            track.time = value * 1000;
        }

        return _tracks.sounds[0].time;
    }

    private function get_bpm():Float {
        return _bpm;
    }

    private function get_timeSignature():TimeSignature {
        return _timeSignature;
    }

    private function get_beatDuration():Float {
        return _beatDuration;
    }

    private function get_curBar():Int {
        return _curBar.value;
    }

    private function get_curBeat():Int {
        return _curBeat.value;
    }

    private function get_curStep():Int {
        return _curStep.value;
    }

    function set_looped(value:Bool):Bool {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        return _tracks.sounds[0].looped = value;
    }

	function get_looped():Bool {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

		return _tracks.sounds[0].looped;
	}

    function get_barDuration():Float {
        return _barDuration;
    }

    function get_currentTimingPoint():TimingPoint {
        return _currentTimingPoint;
    }

    function get_beatMap():Array<TimingPoint> {
        return _beatMap;
    }

    function set_pitch(value:Float):Float {
        if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        for (track in _tracks.sounds) {
            track.pitch = value;
        }

        return value;
    }

	function get_pitch():Float {
		if (_tracks == null || _tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        return _tracks.sounds[0].pitch;
	}
}