package engine.music;

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

class Song extends FlxBasic {
    private var tracks:FlxSoundGroup;

    public var onBar:FlxTypedSignal<Int->Void>;
    public var onBeat:FlxTypedSignal<Int->Void>;
    public var onStep:FlxTypedSignal<Int->Void>;
    
    /**
     * Time in seconds
     */
    public var time(get, set):Float;

    public var looped(get, set):Bool;
    public var playing(get, set):Bool;

    public var volume:Float = 1.0;
    
    public var bpm(get, never):Float;
    public var timeSignature(get, never):TimeSignature;

    public var beatDuration(get, never):Float;

    public var curBar(get, never):Int;
    public var curBeat(get, never):Int;
    public var curStep(get, never):Int;

    private var _playing:Bool = false;
    
    private var _bpm:Float;
    private var _timeSignature:TimeSignature;

    private var _beatMap:Array<TimingPoint> = [];
    
    private var _beatDuration:Float;
    
    private var _curBar:Int;
    private var _curBeat:Int;
    private var _curStep:Int;

    private var _lastBar:Int;
    private var _lastBeat:Int;
    private var _lastStep:Int;

    public function new() {
        super();

        tracks = new FlxSoundGroup();

        onBar = new FlxTypedSignal<Int->Void>();
        onBeat = new FlxTypedSignal<Int->Void>();
        onStep = new FlxTypedSignal<Int->Void>();

        _bpm = 0;
        _timeSignature = new TimeSignature(1, 1);
        
        _beatDuration = 0;
        
        _curBar = 0;
        _curBeat = 0;
        _curStep = 0;

        _lastBeat = -1;
        _lastBar = -1;
        _lastStep = -1;
    }

    /**
     * Sets the current BPM and Time Signature and
     * defines beat and time signature changes in the song.
     * @param bpmChanges Set to null (or nothing) to remove.
     */
    public function setBeatMap(bpmChanges:Array<BPMChangeEvent>) {
        bpmChanges.sort((a, b) -> { // Sort by ascending.
            if (a.occursAt < b.occursAt) return -1;
            if (a.occursAt > b.occursAt) return 1;

            return 0;
        });

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

        for (track in tracks.sounds){
            track.stop();

            track.kill();
            track.destroy();
        }

        super.destroy();
    }

    private var _currentTimingPoint:TimingPoint;

    override public function update(elapsed:Float):Void {
        if (tracks.sounds.length > 0) {
            tracks.volume = volume;

            final mainTrack:FlxSound = tracks.sounds[0];
            mainTrack.update(elapsed);

            for (i in 1...tracks.sounds.length) {
                final track:FlxSound = tracks.sounds[i];

                track.pitch = mainTrack.pitch;
                track.looped = mainTrack.looped;

                if (!track.playing && _playing)
                    track.play();
                else if (track.playing && !_playing)
                    track.pause();

                track.update(elapsed);

                if (track.time < mainTrack.time - 20 || track.time > mainTrack.time + 20) {
                    trace('A track was unsynced! ${track.time / 1000} should be ${mainTrack.time / 1000}');

                    track.time = mainTrack.time;
                }
            }
        }

        super.update(elapsed);

        for (i in 0..._beatMap.length) {
            if (_beatMap[i].startTime > time)
                break;

            _currentTimingPoint = _beatMap[i];
        }

        _bpm = _currentTimingPoint.bpm;
        _timeSignature = _currentTimingPoint.timeSignature;
        _beatDuration = _currentTimingPoint.beatDuration;

        final sectionTime:Float = time - _currentTimingPoint.startTime;

        _curBeat = Math.floor(_currentTimingPoint.prevBeats + (sectionTime / _beatDuration));
        _curStep = Math.floor((_currentTimingPoint.prevBeats * 4) + (sectionTime / (_beatDuration / 4)));
        _curBar = Math.floor(_currentTimingPoint.prevBars + (sectionTime / _currentTimingPoint.barDuration));

        if (_curBeat != _lastBeat) {
            _lastBeat = _curBeat;
            onBeat.dispatch(_curBeat);
        }

        if (_curStep != _lastStep) {
            _lastStep = _curStep;
            onStep.dispatch(_curStep);
        }

        if (_curBar != _lastBar) {
            _lastBar = _curBar;
            onBar.dispatch(_curBar);
        }
    }

    public function addTrack(track:FlxSound) {
        tracks.add(track);
    }

    public function removeTrack(track:FlxSound) {
        track.stop();
        track.kill();

        tracks.remove(track);
    }

    private function get_playing():Bool
        return _playing;

    private function set_playing(value:Bool):Bool {
        if (value == true)
            play();
        else if (value == false)
            pause();

        return _playing;
    }

    public function play():Void {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        _playing = true;

        for (track in tracks.sounds)
            track.play();
    }

    public function pause():Void {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        _playing = false;

        for (track in tracks.sounds)
            track.pause();
    }

    public function clear():Void {
        for (track in tracks.sounds){
            track.stop();

            track.kill();
            track.destroy();
        }

        tracks.sounds = [];
    }

    private function get_time():Float {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        return tracks.sounds[0].time / 1000;
    }

    private function set_time(value:Float):Float {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        for (track in tracks.sounds) {
            track.time = value * 1000;
        }

        return tracks.sounds[0].time;
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
        return _curBar;
    }

    private function get_curBeat():Int {
        return _curBeat;
    }

    private function get_curStep():Int {
        return _curStep;
    }

    function set_looped(value:Bool):Bool {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

        return tracks.sounds[0].looped = value;
    }

	function get_looped():Bool {
        if (tracks == null || tracks.sounds[0] == null)
            throw new haxe.exceptions.ArgumentException("Track is null!");

		return tracks.sounds[0].looped;
	}
}