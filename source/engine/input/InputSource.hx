package engine.input;

import engine.input.Controls;
import engine.objects.ui.Arrow.NoteDirection;
import flixel.FlxG;

class InputSource {
    public function new() {}

    public function inputJustPressed(control:ControlName):Bool { return false; }
    public function inputJustReleased(control:ControlName):Bool { return false; }
    public function inputPressed(control:ControlName):Bool { return false; }

    public function justPressedNoteDirection(direction:NoteDirection):Bool { return false; }
    public function justReleasedNoteDirection(direction:NoteDirection):Bool { return false; }
    public function pressedNoteDirection(direction:NoteDirection):Bool { return false; }
}