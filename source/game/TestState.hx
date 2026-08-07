package game;

import engine.music.Song.TimeSignature;
import engine.states.MusicalState;
import flixel.text.FlxText;

class TestState extends MusicalState
{
	private var _text:FlxText;

	override public function create()
	{
		super.create();

		song.instrumental.load('assets/songs/Beat.ogg');
		song.instrumental.looped = true;
		song.bpm = 120;
		song.timeSignature = new TimeSignature(4, 4);
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
		_text.text = 'curMeasure: ${song.curMeasure}\n'
			+ 'curBeat: ${song.curBeat}\n'
			+ 'curQuarter: ${song.curQuarter}\n'
			+ 'curStep: ${song.curStep}';
	}
}
