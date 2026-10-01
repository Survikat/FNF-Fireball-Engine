package engine.objects.ui;

import animate.FlxAnimateFrames;
import engine.InternalDefs.AnimatedGraphicProperties;
import engine.InternalDefs.AtlasType;
import engine.visuals.Style.GameStyleMeta;
import engine.visuals.Style.NoteStyleMeta;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import haxe.io.Path;

enum ArrowType {
    STRUM;
    NOTE;
    SUSTAIN;
}

final class Arrow extends FBSprite {
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
                _properties = style.strumline;
            case NOTE:
                _properties = style.arrows;
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

        for (selAnim in properties.animations) {
            var fps:Int = 24;
            var offsets:Array<Int> = [];
            var loop:Bool = true;

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
    }

    function get_properties():AnimatedGraphicProperties {
        return _properties;
    }

    function get_arrowType():ArrowType {
        return _arrowType;
    }
}

final class Sustain extends FBSprite {

}