package engine.input.sources;

import engine.input.InputManager.ControlName;
import flixel.input.keyboard.FlxKey;

final class DesktopInputSource extends InputSource {
    override public function new ():Void {
        super();

        // Default Bindings
        bindings.set(LEFT, [FlxKey.LEFT, FlxKey.A]);
        bindings.set(DOWN, [FlxKey.DOWN, FlxKey.S]);
        bindings.set(UP, [FlxKey.UP, FlxKey.W]);
        bindings.set(RIGHT, [FlxKey.RIGHT, FlxKey.D]);

        bindings.set(SELECT, [FlxKey.ENTER, FlxKey.Z]);
        bindings.set(BACK, [FlxKey.ESCAPE, FlxKey.X]);
        bindings.set(PAUSE, [FlxKey.ESCAPE]);
        bindings.set(DEBUG, [FlxKey.SEVEN]);

        
    }

    public function loadKeybinds():Void {
        for (bindName in ControlName.getConstructors()) {
            final key:ControlName = ControlName.createByName(bindName);
        }
    }
}