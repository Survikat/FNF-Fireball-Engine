package engine;

import engine.music.Song;
import flixel.sound.FlxSound;

enum FunkinTracks {
    Instrumental;
    Player;
    Opponent;
    Vocals;
}

class GameUtilty {
    /**
     * Plays the given song to the given song manager.
     * @param manager Song Manager.
     * @param title Song Title.
     * @param instOnly If true, it won't attempt to load vocals.
     * @param dualVocals If true, it will attempt to load seperate vocal tracks. If false, it will attempt to load a singular vocal track.
     * @return Map of tracks; (`Instrumental`, `Player`, `Opponent`, `Vocals`).
     */
    public static function playMusic(manager:Song, title:String, ?instOnly:Bool = false, ?dualVocals:Bool = true):Map<FunkinTracks, FlxSound> {
        manager.clear();

        var _tracks:Map<FunkinTracks, FlxSound> = new Map();

        var _instTrack:FlxSound = new FlxSound();
        var _vocalTrackPlayer:FlxSound = new FlxSound();
        var _vocalTrackOpponent:FlxSound = new FlxSound();

        _instTrack.loadStreamed(Paths.getMusic(title, "Inst"));
        _tracks.set(Instrumental, _instTrack);

        manager.addTrack(_instTrack); // Main track.

        if (!instOnly) {
            if (dualVocals) {
                _vocalTrackPlayer.loadStreamed(Paths.getMusic(title, "Vocals-Player"));
                _tracks.set(Player, _vocalTrackPlayer);

                _vocalTrackOpponent.loadStreamed(Paths.getMusic(title, "Vocals-Opponent"));
                _tracks.set(Opponent, _vocalTrackOpponent);

                manager.addTrack(_vocalTrackPlayer);
                manager.addTrack(_vocalTrackOpponent);
            } else {
                _vocalTrackPlayer.loadStreamed(Paths.getMusic(title, "Vocals"));
                _tracks.set(Vocals, _vocalTrackPlayer);

                manager.addTrack(_vocalTrackPlayer);
            }
        }

        return _tracks;
    }
}