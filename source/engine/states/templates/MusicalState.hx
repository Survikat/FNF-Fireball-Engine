package engine.states.templates;

import engine.input.InputSource;
import engine.input.sources.KeyboardInputSource;
import engine.music.SongManager;
import flixel.FlxState;

class MusicalState extends FBState {
	public var song:SongManager;
    public var controls:InputSource;

    public function new (?song:SongManager = null, ?controls:InputSource) {
        this.song = song;
        this.controls = controls;

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

        if (controls == null) {
            controls = new KeyboardInputSource();
        }

		add(song);
	}

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

	public function barHit(bar:Int):Void {}
	public function beatHit(beat:Int):Void {}
	public function stepHit(step:Int):Void {}
}