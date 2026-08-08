package engine;

import haxe.io.Path;

class Paths {
    public static function getMusic(title:String, track:String):String {
        return Path.normalize('assets/songs/$title/$track.ogg');
    }
}