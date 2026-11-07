package engine.objects.ui;

import engine.visuals.meta.Style.GameStyleMeta;
import engine.visuals.meta.Style.NoteStyleMeta;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class Strumline extends FlxTypedSpriteContainer<FBSprite> {
    private final _defaultArrowSet:Array<String> = [
        "Left",
        "Down",
        "Up",
        "Right"
    ];

    private var _arrowCount:Int = 0;

    public var noteStyle:NoteStyleMeta;
    public var strumArrows:Map<String, Arrow> = new Map();

    override public function new(?x:Float = 0, ?y:Float = 0, ?style:NoteStyleMeta, ?arrows:Array<String>) {
        if (arrows == null)
            arrows = _defaultArrowSet;

        super(x, y);

        if (style == null)
            this.noteStyle = InternalDefs.defaultGameStyle.noteStyle;
        else
            this.noteStyle = style;

        for (arrow in arrows) {
            addArrow(arrow);
        }
    }

    public function addArrow(name:String, ?style:NoteStyleMeta):Void {
        if (style == null)
            style = noteStyle;

        var arrow = new Arrow(style, STRUM);

        if (_arrowCount > 0) {
            arrow.x += (Arrow.arrowWidth + noteStyle.properties.spacing) * _arrowCount;
        }
        
        strumArrows.set(name, arrow);
        ++_arrowCount;

        add(arrow);
        arrow.playAnim('static${name}');
    }
}