package engine.music;

import flixel.FlxG;
import flixel.sound.FlxSound;

class Conductor {
    private static var beatMap:Array<BPMChange> = [];

    private static var _currentBPM:Float;
    private static var _currentSignature:TimeSignature;

    public static var currentBPM(get, never):Float;
    static function get_currentBPM():Float
        return _currentBPM;

    public static var currentSignature(get, never):TimeSignature;
    static function get_currentSignature():TimeSignature
        return _currentSignature;
    
    /**
     * Defines beat and time signature changes in the song.
     * @param beatMap Set to null (or nothing) to remove.
     */
    public static function setBeatMap(?beatMap:Array<BPMChange>) {
        beatMap.sort((a, b) -> {
           if (a.occursAt < b.occursAt) return -1;
           if (a.occursAt > b.occursAt) return 1;
           return 0;
        });

        _currentBPM = beatMap[0].BPM;
        _currentSignature = beatMap[0].timeSignature;

        Conductor.beatMap = beatMap;
    }

    // Passed Steps and Beats.

    private static var _steps:Int = 0;
    private static var _beats:Int = 0;
    private static var _bars:Int = 0;

    public static var steps(get, never):Int;
    static function get_steps():Int
        return _steps;

    public static var beats(get, never):Int;
    static function get_beats():Int
        return _beats;

    public static var bars(get, never):Int;
    static function get_bars():Int
        return _bars;

    public static function update(elapsed:Float):Void {
        /*var msPerQuarter:Float = 60000 / BPM;
        var quarterBeats:Float = elapsed / msPerQuarter;

        var beat:Float = quarterBeats * (timeSignature.Denominator / 4.0);
        _beats = Math.floor(beat);

        _steps = Math.floor(quarterBeats * 4);
        _bars = Math.floor(_beats / timeSignature.Numerator);*/

        /*var msPerBeat:Float = 60000 / BPM;
        var msPerBar:Float = msPerBeat * timeSignature.Numerator;
        var stepsPerBar:Float = msPerBar / 16;*/
    }
}

class TimeSignature {
    public var Numerator:Int = 4;
    public var Denominator:Int = 4;

    public function new (numerator:Int = 4, denominator:Int = 4) {
        this.Numerator = 4;
        this.Denominator = 4;
    }
}

typedef BPMChange = {
    var occursAt:Float;
    var BPM:Float;
    var timeSignature:TimeSignature;
    // These values only affect the BPM.
    var ?endsAt:Float;
    var ?tension:Float; // How linear the change is over time
}