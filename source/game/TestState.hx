package game;

import engine.music.Song.JSONSongEvent;
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

        var events:Array<JSONSongEvent> = Json.parse(FlxG.assets.getText('assets/songs/Beat.json'));
        song.setEvents(events);
		song.play();

		_text = new FlxText();
		_text.size *= 2;
		add(_text);
	}

	override public function stepHit(canonical:Int, elapsed:Int):Void
	{
		super.stepHit(canonical, elapsed);
		_text.text =
			'bar: ${song.bar}\n' 		 +
			'beat: ${song.beat}\n' 		 +
			'quarter: ${song.quarter}\n' +
			'step: ${song.step}\n' 		 +
			'bpm: ${song.bpm}\n' 		 +
			'signature: ${song.timeSignature.numerator} / ${song.timeSignature.denominator}';
	}
}