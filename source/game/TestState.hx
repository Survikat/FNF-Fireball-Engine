package game;

import engine.states.MusicalState;
import flixel.text.FlxText;

class TestState extends MusicalState {
	private var _text:FlxText;

	public function new()
	{
		super('assets/songs/Beat.ogg');
	}
	
    override public function create()
	{
		super.create();
		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}
	
	override public function beatHit(beat:Int):Void
	{
		super.beatHit(beat);
		trace(beat);
	}

	override public function stepHit(step:Int):Void
	{
		super.stepHit(step);
		_text.text =
			'curBeat: ${this.song.curBeat}\n' +
			'curQuarter: ${this.song.curQuarter}\n' +
			'curStep: ${this.song.curStep}';
	}
}