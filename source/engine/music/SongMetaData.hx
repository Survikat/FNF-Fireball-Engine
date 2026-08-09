package engine.music;

typedef SongMetaData = {
    var title:String;
    var album:String;
    var artists:Array<String>;
    var bpm:Float;
    var timeSignature:Array<Int>;
    var ?beatMappings:Array<BPMChangeEvent>;
}

typedef BPMChangeEvent = {
    var occursAt:Float;
    var bpm:Float;
    var timeSignature:Array<Int>;
}