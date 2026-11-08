package engine.input.sources;

import engine.input.Controls;
import engine.objects.ui.Arrow.NoteDirection;
import engine.save.Save;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

final class KeyboardInputSource extends InputSource {
    public var bindings:Map<ControlName, Array<FlxKey>>;

    override public function new ():Void {
        super();

        bindings = new Map();

        bindings.set(LEFT, [FlxKey.LEFT, FlxKey.A]);
        bindings.set(DOWN, [FlxKey.DOWN, FlxKey.S]);
        bindings.set(UP, [FlxKey.UP, FlxKey.W]);
        bindings.set(RIGHT, [FlxKey.RIGHT, FlxKey.D]);

        bindings.set(SELECT, [FlxKey.ENTER, FlxKey.Z]);
        bindings.set(BACK, [FlxKey.ESCAPE, FlxKey.X]);
        bindings.set(PAUSE, [FlxKey.ESCAPE]);
        bindings.set(DEBUG, [FlxKey.SEVEN]);

        loadKeybinds();
    }

    public function loadKeybinds():Void {
        for (bindName in ControlName.getConstructors()) {
            final key:ControlName = ControlName.createByName(bindName);
            final tmpBinds:Dynamic = Save.get('keyboardControls.$bindName');

            try {
                if (tmpBinds != null && (tmpBinds is Array)) {
                    final binds:Array<FlxKey> = tmpBinds;

                    if (binds != null && binds.length > 0) {
                        bindings.set(key, binds);
                    }
                }
            } catch (e:Dynamic) {
                trace('Failed to load keybinds ($e).');
            }
        }
    }

    override function inputJustPressed(control:ControlName):Bool {
        if (bindings.exists(control)) {
            var binds:Array<FlxKey> = bindings.get(control);

            if (FlxG.keys.anyJustPressed(binds)) {
                return true;
            }
        }

        return false;
    }

    override function inputJustReleased(control:ControlName):Bool {
        if (bindings.exists(control)) {
            var binds:Array<FlxKey> = bindings.get(control);

            if (FlxG.keys.anyJustReleased(binds)) {
                return true;
            }
        }

        return false;
    }

    override function inputPressed(control:ControlName):Bool {
        if (bindings.exists(control)) {
            var binds:Array<FlxKey> = bindings.get(control);

            if (FlxG.keys.anyPressed(binds)) {
                return true;
            }
        }

        return false;
    }

    override function justPressedNoteDirection(direction:NoteDirection):Bool {
        switch (direction) {
            case LEFT:
                if (bindings.exists(LEFT))
                    return inputJustPressed(LEFT);
            case DOWN:
                if (bindings.exists(DOWN))
                    return inputJustPressed(DOWN);
            case UP:
                if (bindings.exists(UP))
                    return inputJustPressed(UP);
            case RIGHT:
                if (bindings.exists(RIGHT))
                    return inputJustPressed(RIGHT);
        }

        return false;
    }

    override function justReleasedNoteDirection(direction:NoteDirection):Bool {
        switch (direction) {
            case LEFT:
                if (bindings.exists(LEFT))
                    return inputJustReleased(LEFT);
            case DOWN:
                if (bindings.exists(DOWN))
                    return inputJustReleased(DOWN);
            case UP:
                if (bindings.exists(UP))
                    return inputJustReleased(UP);
            case RIGHT:
                if (bindings.exists(RIGHT))
                    return inputJustReleased(RIGHT);
        }

        return false;
    }

    override function pressedNoteDirection(direction:NoteDirection):Bool {
        switch (direction) {
            case LEFT:
                if (bindings.exists(LEFT))
                    return inputPressed(LEFT);
            case DOWN:
                if (bindings.exists(DOWN))
                    return inputPressed(DOWN);
            case UP:
                if (bindings.exists(UP))
                    return inputPressed(UP);
            case RIGHT:
                if (bindings.exists(RIGHT))
                    return inputPressed(RIGHT);
        }

        return false;
    }    
}