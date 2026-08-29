package engine.objects.characters;

import animate.FlxAnimate;
import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import haxe.Json;
import haxe.io.Path;

using StringTools;

class Character extends FBSprite {
    private var _character:String;
    private var _flip:Bool;

    private var _offsets:Map<String, FlxPoint>;

    public var character(get, never):String;
    private function get_character():String
        return _character;

    public var isIdle(get, never):Bool;
    private function get_isIdle():Bool
        return this.anim.name == "idle" || this.anim.name.startsWith("dance");

    public var danceType:DanceType;

    override public function new(character:String, ?flip:Bool = false, ?worldX:Float = 0, ?worldY:Float = 0) {
        _flip = flip;
        _offsets = new Map();

        super(worldX, worldY);
        useRenderTexture = true;

        setCharacter(character);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function setCharacter(name:String):Void {
        _character = character;
        final characterData:CharacterJson = Json.parse(Resources.getContent('data/characters/$name.json'));

        if (characterData.antialiasing == null)
            this.antialiasing = true;
        else
            this.antialiasing = characterData.antialiasing;

        if (characterData.flip != null)
            this._flip = characterData.flip;

        final atlasType:AtlasType = AtlasType.createByName(characterData.atlasType);
        final path:String = Path.normalize('images/characters/${characterData.path}');

        switch (atlasType) {
            case SPARROW:
                final xmlPath:String = '$path.xml';
                this.frames = FlxAtlasFrames.fromSparrow(Resources.getGraphic(path), Resources.getContent(xmlPath));
            case SPRITEMAP:
                this.frames = FlxAnimateFrames.fromAnimate(Resources.getPath(path));
        }

        for (animData in characterData.animations) {
            final animName:String = animData.name;
            final animSymbol:String = animData.symbol;

            var animFPS:Null<Int> = null;
            var animLoop:Bool = false;

            if (animData.fps != null)
                animFPS = animData.fps;
            if (animData.loop != null)
                animLoop = animData.loop;

            switch (atlasType) {
                case SPARROW:
                    if (animFPS == null)
                        animFPS = 24;

                    this.anim.addByPrefix(animName, animSymbol, animFPS, animLoop, _flip);
                case SPRITEMAP:
                    this.anim.addBySymbol(animName, animSymbol, animFPS, animLoop, _flip);
            }
            
            var offsetX:Float = 0;
            var offsetY:Float = 0;

            if (animData.offset != null) {
                offsetX = animData.offset[0];
                offsetY = animData.offset[1];
            }

            _offsets.set(animName, new FlxPoint(offsetX, offsetY));
        }

        if (characterData.danceType == null)
            this.danceType = BOP;
        else
            this.danceType = characterData.danceType;

        dance();
    }

    private var _lastDance:Int = 0;
    public function dance(?animType:DanceType):Void {
        if (animType == null)
            animType = danceType;
        
        switch (animType) {
            case BOP:
                this.play("idle");
            case DANCE:
                if (_lastDance == 0) {
                    this.play("danceLeft");
                    _lastDance = 1;
                } else {
                    this.play("danceRight");
                    _lastDance = 0;
                }
            case CUSTOM:
                // Lua junk.
        }
    }

    // I can't set the offsets using the build in `offsets` variable since FlxAnimate does some bullshit with it.
    // Have to figure out how to implement later.
    public function play(name:String, ?force:Bool = false):Void {
        this.anim.play(name, force);
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
    var atlasType:String;
    var ?antialiasing:Bool;
    var animations:Array<AnimationData>;
    var ?danceType:DanceType;
    var ?flip:Bool;
}

typedef AnimationData = {
    var name:String;
    var symbol:String;
    var ?fps:Null<Int>;
    var ?loop:Bool;
    var ?offset:Array<Int>;
}