package engine.music;

import engine.music.Conductor.BPMChange;
import engine.music.Conductor.TimeSignature;

typedef SongMeta = {
    var BPM:Float;
    var timeSignature:TimeSignature;
    var beatMap:Array<BPMChange>;
}