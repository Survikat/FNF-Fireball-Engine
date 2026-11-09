package engine.input.sources;

final class GamepadInputSource extends InputSource {
    override public function new() {
        inputMethod = GAMEPAD;

        super();
    }
}