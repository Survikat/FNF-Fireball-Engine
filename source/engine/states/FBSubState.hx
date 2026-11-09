package engine.states;

import engine.input.InputHandler;
import engine.input.InputSource;
import engine.input.sources.GamepadInputSource;
import engine.input.sources.KeyboardInputSource;
import flixel.addons.ui.FlxUISubState;

class FBSubstate extends FlxUISubState {
    public var controls:InputSource;

    override public function new() {
        if (InputHandler.inputMethod == null) {
            #if desktop
            InputHandler.init(new KeyboardInputSource());
            #else
            InputHandler.init(new GamepadInputSource());
            #end
        }

        this.controls = InputHandler.inputMethod;

        super();
    }
}