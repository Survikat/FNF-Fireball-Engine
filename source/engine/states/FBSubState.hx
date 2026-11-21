package engine.states;

import engine.input.InputHandler;
import engine.input.InputSource;
import flixel.addons.ui.FlxUISubState;

class FBSubstate extends FlxUISubState {
    public var controls:InputSource;

    override public function new() {
        this.controls = InputHandler.inputMethod;

        super();
    }
}