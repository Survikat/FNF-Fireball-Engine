package engine.states;

import engine.music.Conductor;

class MusicalState extends TemplateState {
	override public function create()
	{
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

        Conductor.update();
	}
}