package engine.states;

import engine.music.Song;
import flixel.FlxState;

class MusicalState extends FlxState {
	public var song:Song;

    public function new (?song:Song = null) {
        this.song = song;

        super();
    }

	override public function create():Void {
		super.create();
        
        if (song == null) {
            song = new Song();
            song.onBar.add(barHit);
            song.onBeat.add(beatHit);
            song.onStep.add(stepHit);
        }

		add(song);
	}

	public function barHit(bar:Int):Void {}
	public function beatHit(beat:Int):Void {}
	public function stepHit(step:Int):Void {}
}