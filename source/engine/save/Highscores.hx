package engine.save;

import haxe.Json;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

final class Highscores {
    private static var _data:HighscoreData;
    
    public static function init():Void {
        _data = Save.get("highscores");
    }

    public static function setSongScore(name:String, difficulty:String, score:Int, ?modID:String = "BASE") {
        final songID:String = '$name:$difficulty:$modID';
        final scoreFiltered:Array<ScoreData> = _data.songs.filter(item -> item.id == songID);

        if (scoreFiltered != null) {
            for (score in scoreFiltered) {
                _data.songs.remove(score);
            }
        }

        _data.songs.push({
            id: songID,
            score: score
        });
        
        dump();
    }

    public static function setWeekScore(name:String, difficulty:String, score:Int, ?modID:String = "BASE") {
        final weekID:String = '$name:$difficulty:$modID';
        final scoreFiltered:Array<ScoreData> = _data.weeks.filter(item -> item.id == weekID);

        if (scoreFiltered != null) {
            for (score in scoreFiltered) {
                _data.weeks.remove(score);
            }
        }

        _data.weeks.push({
            id: weekID,
            score: score
        });

        dump();
    }

    public static function getWeekScore(name:String, difficulty:String, ?modID:String = "BASE") {
        final weekID:String = '$name:$difficulty:$modID';
        final scoreFiltered:Array<ScoreData> = _data.weeks.filter(item -> item.id == weekID);

        if (scoreFiltered != null && scoreFiltered.length > 0) {
            return scoreFiltered[0];
        }

        return null;
    }

    public static function getSongScore(name:String, difficulty:String, ?modID:String = "BASE") {
        final songID:String = '$name:$difficulty:$modID';
        final scoreFiltered:Array<ScoreData> = _data.songs.filter(item -> item.id == songID);

        if (scoreFiltered != null && scoreFiltered.length > 0) {
            return scoreFiltered[0];
        }

        return null;
    }

    public static function dump():Void {
        Save.set("highscores", _data);
    }

    public static function reset():Void {
        _data = {weeks: [], songs: []};
        dump();
    }
}

typedef ScoreData = {
    var id:String;
    var score:Int;
}

typedef HighscoreData = { // Identifies by `NAME:DIFFICULTY:MODID`.
    var weeks:Array<ScoreData>;
    var songs:Array<ScoreData>;
}