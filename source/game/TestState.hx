package game;

import engine.music.Conductor;
import engine.states.MusicialState;
import flixel.FlxG;

class TestState extends MusicalState {
    override public function create()
	{
		super.create();

        FlxG.sound.playMusic("assets/songs/Beat.ogg");
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

        Conductor.update(FlxG.sound.music.time);
        trace('curStep: ${Conductor.steps} | curBeat: ${Conductor.beats} | curBar: ${Conductor.bars}');
	}
}