package engine.objects.characters;

import animate.FlxAnimate;
import animate.FlxAnimateFrames;

using StringTools;

class Character extends FBSprite {
    private var _character:String;

    public var character(get, never):String;
    private function get_character():String
        return _character;

    public var isIdle(get, never):Bool;
    private function get_isIdle():Bool
        return this.animation.name == "idle" || this.animation.name.startsWith("dance");

    public var danceType:DanceType;

    public var stageX:Float = 0;
    public var stageY:Float = 0;

    override public function new(character:String, ?x:Float = 0, ?y:Float = 0) {
        stageX = x;
        stageY = y;

        super(x, y);
        useRenderTexture = true;

        setCharacter(character);
    }

    public function setCharacter(name:String):Void {
        _character = character;

        switch (name.toLowerCase()) {
            case 'boyfriend':
                antialiasing = true;
                danceType = BOP;

                frames = FlxAnimateFrames.fromAnimate(Resources.getPath("images/characters/bf/"), );
                anim.addBySymbol("idle", "BF idle dance", null, false);
        }

        dance();
    }

    private var _lastDance:Int = 0;
    public function dance(?animType:DanceType):Void {
        if (animType == null)
            animType = danceType;
        
        switch (animType) {
            case BOP:
                this.animation.play("idle");
            case DANCE:
                if (_lastDance == 0) {
                    this.animation.play("danceLeft");
                    _lastDance = 1;
                } else {
                    this.animation.play("danceRight");
                    _lastDance = 0;
                }
            case CUSTOM:
                // Lua junk.
        }
    }
}

enum DanceType {
    BOP; // idle is used.
    DANCE; // danceLeft and danceRight are used.
    CUSTOM;
}

enum AtlasType {
    SPRITEMAP;
    SPARROW;
}

typedef CharacterJson = {
    var path:String; // Starts in `images/characters`
    var animType:AtlasType;
    var animations:Array<AnimationData>;
    var danceType:DanceType;
}

typedef AnimationData = {
    var name:String;
    var symbol:String;
    var ?fps:Int;
    var ?offsets:Array<Int>;
}