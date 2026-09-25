package engine.visuals;

import engine.InternalDefs;

typedef GameStyleMeta = {
    var noteStyle:NoteStyleMeta;
    var countdownDir:String;
    var healthbarPath:String;
}

typedef NoteStyleMeta = {
    var strumline:AnimatedGraphicProperties;
    var splashes:AnimatedGraphicProperties;
    var arrows:AnimatedGraphicProperties;
    var strums:StandardGraphicProperties;
}