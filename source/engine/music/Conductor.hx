package engine.music;

import flixel.FlxG;
import flixel.sound.FlxSound;

class Conductor {
    public static var BPM:Int = 120;
    public static var timeSignature:TimeSignature = new TimeSignature();

    /**
     * If you change this value, make sure to run `Conductor.update()`!
     */
    public static var tracker:FlxSound = FlxG.sound.music;
    

    // Figure out how to implement properly later.
    /*public static function changeBPM(BPM:Int = 120, timeSignature:TimeSignature) {
        Conductor.BPM = BPM;
        Conductor.timeSignature = timeSignature;
    }*/

    /**
     * Just a quicker method of setting the current position of the music
     * without having to call the update function manually.
     * @param ms Target time in milliseconds.
     */
    public static function setTime(ms:Float) {
        tracker.time = ms;
        update();
    }

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

    public static function update():Void {
        var musicPos:Float = tracker.time;

        var msPerQuarter:Float = 60000 / BPM;
        var quarterBeats:Float = musicPos / msPerQuarter;

        var beat:Float = quarterBeats * (timeSignature.Denominator / 4.0);
        _beats = Math.floor(beat);

        _steps = Math.floor(quarterBeats * 4);
        _bars = Math.floor(_beats / timeSignature.Numerator);
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