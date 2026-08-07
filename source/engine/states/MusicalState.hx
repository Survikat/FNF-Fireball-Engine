package engine.states;

import engine.music.Song;
import flixel.FlxState;

class MusicalState extends FlxState {
	public var song:Song;

	override public function create():Void
	{
		super.create();
        
		song = new Song();
		song.onMeasure.add(measureHit);
		song.onBeat.add(beatHit);
		song.onQuarter.add(quarterHit);
		song.onStep.add(stepHit);
		add(song);
	}

	public function measureHit(measure:Int):Void {}
	public function beatHit(beat:Int):Void {}
	public function quarterHit(quarter:Int):Void {}
	public function stepHit(step:Int):Void {}
}