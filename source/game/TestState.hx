package game;

import engine.music.Song.BPMChangeEvent;
import engine.music.Song.TimeSignature;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.text.FlxText;
import haxe.Json;

class TestState extends MusicalState {
	private var _text:FlxText;
	
    override public function create()
	{
		super.create();
		
		song.instrumental.load('assets/songs/Beat.ogg');
		song.instrumental.looped = true;

        var beatMappings:Array<BPMChangeEvent> = Json.parse(FlxG.assets.getText("assets/songs/Beat.json"));
        song.setBeatMap(beatMappings);

		song.play();

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

	override public function measureHit(measure:Int):Void
	{
		super.measureHit(measure);
		trace('hello');
	}

	override public function stepHit(step:Int):Void
	{
		super.stepHit(step);
		_text.text =
			'curMeasure: ${song.curMeasure}\n' +
			'curBeat: ${song.curBeat}\n' +
			'curQuarter: ${song.curQuarter}\n' +
			'curStep: ${song.curStep}\n\n' +
            '${song.timeSignature.numerator}/${song.timeSignature.denominator} ${song.bpm}';
	}
}