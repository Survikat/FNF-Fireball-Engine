package engine.input;

final class InputHandler {
    private static var _method:InputSource;
    public static var inputMethod(get, never):InputSource;

    public static function init(method:InputSource):Void {
        _method = method;
    }

    private static function get_inputMethod():InputSource {
        return _method;
    }
}