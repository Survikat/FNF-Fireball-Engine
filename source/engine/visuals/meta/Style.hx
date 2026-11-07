package engine.visuals.meta;

import engine.InternalDefs;

typedef GameStyleMeta = {
    var noteStyle:NoteStyleMeta;
    var countdownDir:String;
    var healthbarPath:String;
}

typedef NoteStyleMeta = {
    var strums:AnimatedGraphicProperties;
    var ?splashes:AnimatedGraphicProperties;
    var notes:AnimatedGraphicProperties;
    var sustain:StandardGraphicProperties;
    var properties:NoteStyleProperties;
}

typedef NoteStyleProperties = {
    var spacing:Float;
    var enableSplashes:Bool;
}