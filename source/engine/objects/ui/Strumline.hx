package engine.objects.ui;

import engine.input.InputSource;
import engine.objects.ui.Arrow.NoteDirection;
import engine.visuals.meta.Style.GameStyleMeta;
import engine.visuals.meta.Style.NoteStyleMeta;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class Strumline extends FlxContainer {
    public var noteStyle:NoteStyleMeta;
    public var strumArrowMap:Map<NoteDirection, Arrow> = new Map();

    private var _strumArrowCount:Int = 0;

    private var _strumArrows:FlxTypedSpriteContainer<Arrow>;
    private var _noteArrows:FlxTypedSpriteContainer<Note>;
    private var _noteSplashes:FlxTypedSpriteContainer<FBSprite>;

    public var controls:InputSource;

    public var x(get, set):Float;
    public var y(get, set):Float;

    public var width(get, never):Float;
    public var height(get, never):Float;

    public var scrollSpeed:Float = 1;
    public var autoPlay:Bool = true;

    /**
     * Member ID's should corespond to their index. 
     **/
    public var strumArrowMembers(get, never):Array<Arrow>;
    public var noteArrowMembers(get, never):Array<Note>;

    override public function new(?x:Float = 0, ?y:Float = 0, ?style:NoteStyleMeta, ?inputSource:InputSource) {
        _strumArrows = new FlxTypedSpriteContainer(x, y);
        _noteArrows = new FlxTypedSpriteContainer(x, y);
        _noteSplashes = new FlxTypedSpriteContainer(x, y);

        controls = inputSource;

        super();

        if (style == null)
            this.noteStyle = InternalDefs.defaultGameStyle.noteStyle;
        else
            this.noteStyle = style;

        for (direction in Arrow.usualNoteDirectionOrder) {
            addArrow(direction, noteStyle);
        }

        add(_strumArrows);
        add(_noteArrows);
        add(_noteSplashes);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        for (i in 0...Arrow.usualNoteDirectionOrder.length) {
            final arrow:Arrow = _strumArrows.members[i];
            final direction:NoteDirection = Arrow.usualNoteDirectionOrder[i];
            final name:String = Arrow.retrieveNameFromDirection(direction);

            if (controls != null) {
                if (controls.justPressedNoteDirection(direction)) {
                    arrow.playAnim('press${name}');
                }
            }

            if (controls != null && arrow.anim.finished) {
                if (!controls.pressedNoteDirection(direction)) {
                    arrow.playAnim('static${name}');
                }
            } else if (arrow.anim.finished) {
                arrow.playAnim('static${name}');
            }
        }
    }

    public function addArrow(direction:NoteDirection, ?style:NoteStyleMeta):Void {
        if (style == null)
            style = noteStyle;

        var arrow = new Arrow(style, STRUM);
        arrow.ID = _strumArrowCount;

        if (_strumArrowCount > 0) {
            arrow.x += (Arrow.arrowWidth + noteStyle.properties.spacing) * _strumArrowCount;
        }

        final name:String = Arrow.retrieveNameFromDirection(direction);
        
        strumArrowMap.set(direction, arrow);
        ++_strumArrowCount;

        arrow.playAnim('static${name}');
        _strumArrows.add(arrow);
    }

    function set_x(value:Float):Float {
        return _strumArrows.x = _noteArrows.x = _noteSplashes.x = value;
    }

	function get_x():Float {
		return _strumArrows.x;
	}

    function set_y(value:Float):Float {
        return _strumArrows.y = _noteArrows.y = _noteSplashes.y = value;
    }

	function get_y():Float {
		return _strumArrows.y;
	}

    function get_strumArrowMembers():Array<Arrow> {
        return _strumArrows.members;
    }

    function get_noteArrowMembers():Array<Note> {
        return _noteArrows.members;
    }

    function get_width():Float {
        return _strumArrows.width;
    }

    function get_height():Float {
        return _strumArrows.height;
    }
}