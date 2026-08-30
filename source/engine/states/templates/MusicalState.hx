package engine.states.templates;

import engine.music.SongManager;
import flixel.FlxState;

class MusicalState extends FBState {
	public var song:SongManager;

    public function new (?song:SongManager = null) {
        this.song = song;

        super();
    }

	override public function create():Void {
		super.create();
        
        if (song == null) {
            song = new SongManager();
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