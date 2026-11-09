package engine.input;

import engine.objects.ui.Arrow.NoteDirection;

class InputSource {
    public var inputMethod:InputMethod = NONE;

    private var _controlSet:Array<String> = [];

    public var controlSet(get, never):Array<String>;
    public var controlOrder:Array<String> = [];

    public function new() {
        addControlOpt("LEFT");
        addControlOpt("DOWN");
        addControlOpt("UP");
        addControlOpt("RIGHT");

        addControlOpt("SELECT");
        addControlOpt("BACK");
        addControlOpt("PAUSE");
        addControlOpt("DEBUG");
    }

    public function inputJustPressed(control:String):Bool { return false; }
    public function inputJustReleased(control:String):Bool { return false; }
    public function inputPressed(control:String):Bool { return false; }

    public function justPressedNoteDirection(direction:NoteDirection):Bool { return false; }
    public function justReleasedNoteDirection(direction:NoteDirection):Bool { return false; }
    public function pressedNoteDirection(direction:NoteDirection):Bool { return false; }

    public final function addControlOpt(control:String):Void {
        control = control.toUpperCase();

        if (!_controlSet.contains(control)) {
            _controlSet.push(control);
            controlOrder.push(control);
        }
    }

    public final function removeControlOpt(name:String):Void {
        name = name.toUpperCase();

        for (opt in _controlSet) {
            if (opt == name) {
                _controlSet.remove(opt);
                break;
            }
        }
    }

    private final function get_controlSet():Array<String> {
        return _controlSet;
    }
}

enum InputMethod {
    NONE;
    KEYBOARD;
    GAMEPAD;
}