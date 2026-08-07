package engine.states;

import engine.music.Conductor;

class MusicalState extends TemplateState {
	override public function create()
	{
		super.create();
	}

    private var lastStep:Int;
    private var lastBeat:Int;
    private var lastBar:Int;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}