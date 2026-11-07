package engine.input;

import engine.input.InputManager;
import flixel.FlxG;

class InputSource {
    public var bindings:Map<ControlName, Array<Dynamic>>;

    public function new() {
        bindings = new Map();
    }

    public function inputJustPressed():Bool { return false; }
    public function inputPressed():Bool { return false; }
}