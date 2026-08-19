package engine;

import haxe.io.Path;

class Paths {
    private static function getDir(dir:PathDirectory):String {
        switch (dir) {
            case ASSETS:
                return "assets";
            case RESOURCES:
                return "resources";
        }

        trace('Do not have instance for $dir.');
        return "assets";
    }

    public static function getMusic(title:String, track:String, ?dir:PathDirectory = ASSETS):String {
        return Path.normalize('${getDir(dir)}/songs/$title/$track.ogg');
    }

    public static function getImage(name:String, ?dir:PathDirectory = ASSETS):String {
        return Path.normalize('${getDir(dir)}/images/$name.png');
    }

    public static function get(path:String, ?dir:PathDirectory = ASSETS):String {
        return Path.normalize('${getDir(dir)}/$path');
    }
}

enum PathDirectory {
    ASSETS;
    RESOURCES;
}