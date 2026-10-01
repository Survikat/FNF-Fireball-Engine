package engine.objects.ui;

import engine.visuals.Style.GameStyleMeta;
import engine.visuals.Style.NoteStyleMeta;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class Strumline extends FlxTypedSpriteContainer<FBSprite> {
    public var strums:Array<Arrow> = [];
    public var noteStyle:NoteStyleMeta;

    override public function new(?x:Float = 0, ?y:Float = 0, ?style:NoteStyleMeta) {
        super(x, y);

        if (style == null)
            this.noteStyle = InternalDefs.defaultGameStyle.noteStyle;
        else
            this.noteStyle = style;

        addArrow("Left");
        addArrow("Down");
        addArrow("Up");
        addArrow("Right");
    }

    public function addArrow(name:String, ?style:NoteStyleMeta):Void {
        if (style == null)
            style = noteStyle;

        var arrow = new Arrow(style, STRUM);

        if (strums.length > 0) {
            arrow.x += strums[strums.length - 1].width * strums.length;
        }
        
        strums.push(arrow);
        add(arrow);

        arrow.playAnim('static${name}');
    }
}