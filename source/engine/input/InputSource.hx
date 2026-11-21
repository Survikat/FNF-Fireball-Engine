package engine.input;

class InputSource {
    public var inputMethod:InputMethod = NONE;

    public function new() {
        /*addControlOpt("LEFT");
        addControlOpt("DOWN");
        addControlOpt("UP");
        addControlOpt("RIGHT");

        addControlOpt("SELECT");
        addControlOpt("BACK");
        addControlOpt("PAUSE");
        addControlOpt("DEBUG");*/
    }
}

enum InputMethod {
    NONE;
    KEYBOARD;
    GAMEPAD;
}