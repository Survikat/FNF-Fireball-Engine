package game;

import engine.music.Song.TimeSignature;
import engine.music.SongMeta;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.text.FlxText;
import haxe.Json;

class TestState extends MusicalState {
	private var _text:FlxText;
	
    override public function create() {
		super.create();
		
		song.instrumental.load('assets/songs/Beat.ogg');
		song.instrumental.looped = true;

        final songMeta:SongMeta = Json.parse(FlxG.assets.getText("assets/songs/Beat.json"));
        final beatMappings:Array<BPMChangeEvent> = songMeta.beatMappings;

        song.setBeatMap(beatMappings);
		song.play();

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);
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