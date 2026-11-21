package engine.objects.ui;

import engine.input.InputSource;
import engine.objects.ui.arrows.Arrow;
import engine.objects.ui.arrows.Note;
import engine.visuals.meta.Style.GameStyleMeta;
import engine.visuals.meta.Style.NoteStyleMeta;
import flixel.FlxG;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.math.FlxPoint;

class Strumline extends FlxContainer {
    private var _strumArrows:FlxTypedSpriteContainer<Arrow>;
    private var _notes:FlxTypedSpriteContainer<Note>;
    private var _noteSplashes:FlxTypedSpriteContainer<FBSprite>;

    private var _strumArrowCount:Int = 0;

    public var controls:InputSource;

    public var noteStyle:NoteStyleMeta;
    public var noteKeyOrder:Array<String>;
    public var strumArrowMap:Map<String, Arrow> = new Map();

    public var x(get, set):Float;
    public var y(get, set):Float;
    public var width(get, never):Float;

    public var scrollSpeed:Float = 1;
    public var autoPlay:Bool = true;

    /**
     * Member ID's should corespond to their index. 
     **/
    public var strumArrowMembers(get, never):Array<Arrow>;
    public var noteArrowMembers(get, never):Array<Note>;

    override public function new(?x:Float = 0, ?y:Float = 0, ?style:NoteStyleMeta, ?keyOrder:Array<String>, ?inputSource:InputSource) {
        _strumArrows = new FlxTypedSpriteContainer(x, y);
        _notes = new FlxTypedSpriteContainer(x, y);
        _noteSplashes = new FlxTypedSpriteContainer(x, y);

        controls = inputSource;

        if (keyOrder == null)
            noteKeyOrder = Arrow.fourKeyOrder;
        else
            noteKeyOrder = keyOrder;

        super();

        if (style == null)
            this.noteStyle = InternalDefs.defaultGameStyle.noteStyle;
        else
            this.noteStyle = style;

        for (direction in noteKeyOrder) {
            addArrow(direction, noteStyle);
        }

        add(_strumArrows);
        add(_notes);
        add(_noteSplashes);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        for (i in 0..._strumArrows.members.length) {
            var arrow:Arrow = _strumArrows.members[i];
            final noteType:String = arrow.type;

            /*if (!autoPlay) {
                if (controls.justPressedNoteDirection(direction))
                    arrow.playAnim('press${name}', true);

                if (arrow.anim.finished && !controls.pressedNoteDirection(direction))
                    arrow.playAnim('static${name}');

                // Control bullshit
            } else {
                if (arrow.anim.finished)
                    arrow.playAnim('static${name}');

                // Hit notes and shit
            }*/
        }
    }

    public function addArrow(type:String, ?style:NoteStyleMeta):Void {
        if (style == null)
            style = noteStyle;

        var arrow = new Arrow(style, STRUM);
        arrow.ID = _strumArrowCount;

        if (_strumArrowCount > 0) {
            arrow.x += (Arrow.arrowWidth + noteStyle.properties.spacing) * _strumArrowCount;
        }

        final name:String = type;
        
        strumArrowMap.set(type, arrow);
        ++_strumArrowCount;

        arrow.playAnim('static${name}');
        _strumArrows.add(arrow);
    }

    private final function set_x(value:Float):Float {
        return _strumArrows.x = _notes.x = _noteSplashes.x = value;
    }

	private final function get_x():Float {
		return _strumArrows.x;
	}

    private final function set_y(value:Float):Float {
        return _strumArrows.y = _notes.y = _noteSplashes.y = value;
    }

	private final function get_y():Float {
		return _strumArrows.y;
	}

    private final function get_strumArrowMembers():Array<Arrow> {
        return _strumArrows.members;
    }

    private final function get_noteArrowMembers():Array<Note> {
        return _notes.members;
    }

    private final function get_width():Float {
        return _strumArrows.width;
    }
}