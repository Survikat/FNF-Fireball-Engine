package engine;

import engine.visuals.Style.GameStyleMeta;

enum AtlasType {
    SPRITEMAP;
    SPARROW;
}

/**
 * Used for typedefs and enums that get used commonly,
 * but the class its self stores default properties that utilize them.
 */
final class InternalDefs {
    public static final defaultGameStyle:GameStyleMeta = {
        countdownDir: "countdown/default",
        healthbarPath: "healthBar",
        noteStyle: {
            strumline: {
                path: "noteStrumline",
                atlasType: "SPARROW",
                animations: [

                ]
            },
            splashes: {
                path: "noteSplashes",
                atlasType: "SPARROW",
                animations: [

                ]
            },
            arrows: {
                path: "notes",
                atlasType: "SPARROW",
                animations: [

                ]
            },
            strums: {
                path: "NOTE_hold_assets",
                animated: true,
                width: 52,
                height: 87
            }
        }
    };
}

typedef AnimationData = {
    var name:String;
    var symbol:String;
    var ?fps:Null<Int>;
    var ?loop:Bool;
    var ?offsets:Array<Int>;
}

typedef AnimatedGraphicProperties = {
    var path:String; // Starts in `images`
    var atlasType:String;
    var animations:Array<AnimationData>;
    var ?scale:Float;
    var ?antialiasing:Bool;
}

typedef StandardGraphicProperties = {
    var path:String; // Starts in `images`
    var animated:Bool;
    var ?width:Int;
    var ?height:Int;
    var ?scale:Float;
    var ?antialiasing:Bool;
}