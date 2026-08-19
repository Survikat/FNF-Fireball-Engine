package engine.save;

import haxe.Json;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

class Highscores {
    private static var _data:HighscoreData;
    
    public static function init():Int {
        if (FileSystem.exists("highscores.dat")) {
            try {
                _data = Json.parse(Base64.decode(File.getContent("highscores.dat")).toString());
            } catch(e:Dynamic) {
                trace('Failed to load save data! ($e). Resetting...');

                reset();
                return 2;
            }

            return 0;
        }

        trace('Save data does not exist! Resetting...');

        reset();
        return 1;
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
        File.saveContent("highscores.dat", Base64.encode(Bytes.ofString(Json.stringify(_data, "\t"))));
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