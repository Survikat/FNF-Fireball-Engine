package game;

import engine.GameUtilty;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.text.FlxText;

class TestState extends MusicalState {
	private var _text:FlxText;

    override public function create() {
		super.create();

        // GameUtilty.playMusic(song, "Dual-Killers");
        GameUtilty.playMusic(song, "Beat", true);
        
		song.play();

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.SPACE) {
            if (song.playing)
                song.play();
            else
                song.pause();
        } else {
            if (FlxG.keys.pressed.LEFT)
                song.time -= 2.5 * elapsed;
            else if (FlxG.keys.pressed.RIGHT)
                song.time += 2.5 * elapsed;
        }
    }

	override public function stepHit(step:Int):Void {
		super.stepHit(step);

        _text.text =
        'curBar: ${song.curBar}\n' +
        'curBeat: ${song.curBeat}\n' +
        'curStep: ${song.curStep}\n\n' +
        '${song.timeSignature.numerator}/${song.timeSignature.denominator} @ ${song.bpm}BPM.';
	}
}