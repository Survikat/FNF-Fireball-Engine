package engine.objects.ui;

import engine.objects.ui.Arrow.NoteDirection;
import engine.visuals.meta.Style.NoteStyleMeta;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

final class Note extends FlxTypedSpriteContainer<Arrow> {
    private var noteStyle:NoteStyleMeta;

    override public function new(x:Float, y:Float, style:NoteStyleMeta, direction:NoteDirection) {
        if (style == null)
            this.noteStyle = InternalDefs.defaultGameStyle.noteStyle;
        else
            this.noteStyle = style;

        super(x, y, 256);

        var note:Arrow = new Arrow(noteStyle, NOTE);
        note.playAnim('note${Arrow.retrieveNameFromDirection(direction)}');
        add(note);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}