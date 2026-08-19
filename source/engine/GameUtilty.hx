package engine;

import engine.Paths.PathDirectory;
import engine.music.SongManager;
import engine.music.SongMetaData;
import flixel.FlxG;
import flixel.sound.FlxSound;
import haxe.Json;

enum FunkinTracks {
    Instrumental;
    Player;
    Opponent;
    Duet;
}

class GameUtilty {
    /**
     * Plays the given song to the given song manager.
     * @param manager Song Manager.
     * @param title Song Title.
     * @param instOnly If true, it won't attempt to load vocals.
     * @param dualVocals If true, it will attempt to load seperate vocal tracks. If false, it will attempt to load a singular vocal track.
     * @return Map of tracks; (`Instrumental`, `Player`, `Opponent`, `Duet`).
     */
    public static function playMusic(manager:SongManager, title:String, ?dir:PathDirectory = ASSETS, ?instOnly:Bool = false, ?dualVocals:Bool = true):Map<FunkinTracks, FlxSound> {
        manager.clear();

        var tracks:Map<FunkinTracks, FlxSound> = new Map();

        var instTrack:FlxSound = new FlxSound();
        var vocalTrackPlayer:FlxSound = new FlxSound();
        var vocalTrackOpponent:FlxSound = new FlxSound();

        instTrack.loadStreamed(Paths.getMusic(title, "Inst", dir));
        tracks.set(Instrumental, instTrack);

        var songMeta:SongMetaData = Json.parse(FlxG.assets.getText(Paths.get('songs/$title/$title.json', ASSETS)));
        var beatMappings:Array<BPMChangeEvent> = songMeta.beatMappings;

        if (beatMappings != null) {
            var containsStartingPosition:Bool = false;

            for (beatChange in beatMappings) {
                if (beatChange.occursAt == 0) {
                    containsStartingPosition = true;
                    break;
                }
            }

            if (!containsStartingPosition) {
                beatMappings.push({
                    occursAt: 0,
                    bpm: songMeta.bpm,
                    timeSignature: songMeta.timeSignature
                });
            }
        } else {
            beatMappings = [{
                occursAt: 0,
                bpm: songMeta.bpm,
                timeSignature: songMeta.timeSignature
            }];
        }

        manager.addTrack(instTrack); // Main track.
        manager.setBeatMap(beatMappings);

        if (!instOnly) {
            if (dualVocals) {
                vocalTrackPlayer.loadStreamed(Paths.getMusic(title, "Vocals-Player"));
                tracks.set(Player, vocalTrackPlayer);

                vocalTrackOpponent.loadStreamed(Paths.getMusic(title, "Vocals-Opponent"));
                tracks.set(Opponent, vocalTrackOpponent);

                manager.addTrack(vocalTrackPlayer);
                manager.addTrack(vocalTrackOpponent);
            } else {
                vocalTrackPlayer.loadStreamed(Paths.getMusic(title, "Vocals"));
                tracks.set(Duet, vocalTrackPlayer);

                manager.addTrack(vocalTrackPlayer);
                vocalTrackOpponent.destroy();
            }
        }

        return tracks;
    }
}