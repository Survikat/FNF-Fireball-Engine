package engine.states;

import engine.music.Song;
import flixel.FlxState;

class MusicalState extends FlxState {
	public var song:Song;

	override public function create():Void
	{
		super.create();
        
		song = new Song();
		song.onBar.add(barHit);
		song.onBeat.add(beatHit);
		song.onQuarter.add(quarterHit);
		song.onStep.add(stepHit);
		
		add(song);
	}

	public function barHit(canonical:Int, elapsed:Int):Void {}
	public function beatHit(canonical:Int, elapsed:Int):Void {}
	public function quarterHit(canonical:Int, elapsed:Int):Void {}
	public function stepHit(canonical:Int, elapsed:Int):Void {}
}