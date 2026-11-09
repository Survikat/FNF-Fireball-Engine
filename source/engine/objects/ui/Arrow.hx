package engine.objects.ui;

import animate.FlxAnimateFrames;
import engine.InternalDefs.AnimatedGraphicProperties;
import engine.InternalDefs.AtlasType;
import engine.visuals.meta.Style.GameStyleMeta;
import engine.visuals.meta.Style.NoteStyleMeta;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import haxe.io.Path;

enum ArrowType {
    STRUM;
    NOTE;
    SUSTAIN;
}

final class Arrow extends FBSprite {
    public static final arrowWidth:Int = 150;
    public static final usualNoteDirectionOrder:Array<NoteDirection> = [LEFT, DOWN, UP, RIGHT];

    private var _properties:AnimatedGraphicProperties;
    private var _arrowType:ArrowType;

    public var noteStyle:NoteStyleMeta;

    public var arrowType(get, never):ArrowType;
    public var properties(get, never):AnimatedGraphicProperties;

    override public function new(style:NoteStyleMeta, type:ArrowType) {
        super();

        _arrowType = type;
        switch (arrowType) {
            case STRUM:
                _properties = style.strums;
            case NOTE:
                _properties = style.notes;
            case SUSTAIN:
                throw haxe.exceptions.NotImplementedException;
        }

        final atlasType:AtlasType = AtlasType.createByName(properties.atlasType);
        final path:String = Path.normalize('images/${properties.path}');

        switch (atlasType) {
            case SPARROW:
                useRenderTexture = false;

                final xmlPath:String = '$path.xml';
                this.frames = FlxAtlasFrames.fromSparrow(Resources.getGraphic(path), Resources.getContent(xmlPath));
            case SPRITEMAP:
                useRenderTexture = true;

                this.frames = FlxAnimateFrames.fromAnimate(Resources.getPath(path));
        }

        if (properties.antialiasing == null)
            this.antialiasing = true;
        else
            this.antialiasing = false;

        for (selAnim in properties.animations) {
            var fps:Int = 24;
            var offsets:Array<Int> = [];
            var loop:Bool = false;

            if (selAnim.fps != null)
                fps = selAnim.fps;
            if (selAnim.offsets != null)
                offsets = selAnim.offsets;
            if (selAnim.loop != null)
                loop = selAnim.loop;

            switch (atlasType) {
                case SPARROW:
                    anim.addByPrefix(selAnim.name, selAnim.symbol, fps, loop);
                case SPRITEMAP:
                    anim.addBySymbol(selAnim.name, selAnim.symbol, fps, loop);
            }

            animationOffsets.set(selAnim.name, new FlxPoint(offsets[0], offsets[1]));
        }

        scaleSprite(Arrow.arrowWidth);
    }

    function get_properties():AnimatedGraphicProperties {
        return _properties;
    }

    function get_arrowType():ArrowType {
        return _arrowType;
    }

    public static function retrieveNameFromDirection(direction:NoteDirection):String {
        var name:String = "Left";

        switch (direction) {
            case LEFT:
                name = "Left";
            case DOWN:
                name = "Down";
            case UP:
                name = "Up";
            case RIGHT:
                name = "Right";
        }

        return name;
    }
}

final class Sustain extends FBSprite {

}

enum NoteDirection {
    LEFT;
    RIGHT;
    DOWN;
    UP;
}