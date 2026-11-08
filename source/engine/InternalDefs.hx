package engine;

import engine.visuals.meta.Style.GameStyleMeta;

// Used for typedefs and enums that get used commonly, as well as default internal values and properties.

enum AtlasType {
    SPRITEMAP;
    SPARROW;
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

final class InternalDefs {
    public static final defaultGameStyle:GameStyleMeta = {
        countdownDir: "countdown/default",
        healthbarPath: "healthBar",
        noteStyle: {
            strums: {
                path: "noteStrumline",
                atlasType: "SPARROW",
                animations: [
                    {
                        name: "confirmLeft",
                        symbol: "confirmLeft",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmHoldLeft",
                        symbol: "confirmHoldLeft",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmDown",
                        symbol: "confirmDown",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmHoldDown",
                        symbol: "confirmHoldDown",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmUp",
                        symbol: "confirmUp",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmHoldUp",
                        symbol: "confirmHoldUp",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmRight",
                        symbol: "confirmRight",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "confirmHoldRight",
                        symbol: "confirmHoldRight",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "pressLeft",
                        symbol: "pressLeft",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "pressDown",
                        symbol: "pressDown",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "pressUp",
                        symbol: "pressUp",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "pressRight",
                        symbol: "pressRight",
                        loop: false,
                        fps: 24
                    },
                    {
                        name: "staticLeft",
                        symbol: "staticLeft",
                        fps: 24
                    },
                    {
                        name: "staticDown",
                        symbol: "staticDown",
                        fps: 24
                    },
                    {
                        name: "staticUp",
                        symbol: "staticUp",
                        fps: 24
                    },
                    {
                        name: "staticRight",
                        symbol: "staticRight",
                        fps: 24
                    },
                ]
            },
            // Implement later
            /*splashes: {
                path: "noteSplashes",
                atlasType: "SPARROW",
                animations: []
            },*/
            notes: {
                path: "notes",
                atlasType: "SPARROW",
                animations: [
                    {
                        name: "left",
                        symbol: "noteLeft"
                    },
                    {
                        name: "down",
                        symbol: "noteDown"
                    },
                    {
                        name: "up",
                        symbol: "noteUp"
                    },
                    {
                        name: "right",
                        symbol: "noteRight"
                    }
                ]
            },
            sustain: {
                path: "NOTE_hold_assets",
                animated: true,
                width: 52,
                height: 87
            },
            properties: {
                spacing: -37.5, // 150 / 4
                enableSplashes: false
            }
        }
    };
}