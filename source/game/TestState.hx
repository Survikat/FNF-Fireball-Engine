package game;

import engine.GameUtilty;
import engine.music.Song.TimeSignature;
import engine.music.SongMetaData;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import haxe.Json;

class TestState extends MusicalState {
	private var _text:FlxText;
	
    override public function create() {
		super.create();

        // GameUtilty.playMusic(song, "Dual-Killers");
        // final songMeta:SongMetaData = Json.parse(FlxG.assets.getText("assets/songs/Dual-Killers/Dual-Killers.json"));

        GameUtilty.playMusic(song, "Beat", true); // This will automatically set the beat mappings in the future.
        final songMeta:SongMetaData = Json.parse(FlxG.assets.getText("assets/songs/Beat/Beat.json"));

        final beatMappings:Array<BPMChangeEvent> = songMeta.beatMappings;
        song.setBeatMap(beatMappings);
        
		song.play();

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            song.playing = !song.playing;
        } else {
            if (FlxG.keys.pressed.LEFT)
                song.time -= 2.5 * elapsed;
            else if (FlxG.keys.pressed.RIGHT)
                song.time += 2.5 * elapsed;
        }
    }

	override public function stepHit(step:Int):Void {
		super.stepHit(step);

        _text.text =
        'curBar: ${song.curBar}\n' +
        'curBeat: ${song.curBeat}\n' +
        'curStep: ${song.curStep}\n\n' +
        '${song.timeSignature.numerator}/${song.timeSignature.denominator} @ ${song.bpm}BPM.';
	}
}