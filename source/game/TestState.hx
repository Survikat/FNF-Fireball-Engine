package game;

import engine.GameUtilty;
import engine.Paths;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class TestState extends MusicalState {
	private var _text:FlxText;

    private var _logo:FlxSprite;
    private var _logoBaseScale:Float = 0.5;

    override public function create() {
		super.create();

        // GameUtilty.playMusic(song, "Dual-Killers");
        GameUtilty.playMusic(song, "Beat", true);
        
		song.play();
        song.looped = true;

        _logo = new FlxSprite().loadGraphic(Paths.getImage("logo"));
        _logo.antialiasing = true;
        _logo.updateHitbox();
        _logo.screenCenter(XY);
        add(_logo);

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

            if (FlxG.keys.pressed.UP)
                song.pitch = FlxMath.roundDecimal(song.pitch + (2.5 * elapsed), 2);
            else if (FlxG.keys.pressed.DOWN)
                song.pitch = FlxMath.roundDecimal(song.pitch - (2.5 * elapsed), 2);
        }

        _logo.scale.x = FlxMath.lerp(_logo.scale.x, _logoBaseScale, FlxMath.getElapsedLerp(0.4, elapsed));
        _logo.scale.y = FlxMath.lerp(_logo.scale.y, _logoBaseScale, FlxMath.getElapsedLerp(0.4, elapsed));
        _logo.centerOrigin();

        _text.text =
        'curBar: ${song.curBar}\n' +
        'curBeat: ${song.curBeat}\n' +
        'curStep: ${song.curStep}\n\n' +
        '${song.timeSignature.numerator}/${song.timeSignature.denominator} @ ${song.bpm}BPM\n' +
        'Pitch: ${song.pitch}.';
    }

	override public function stepHit(step:Int):Void {
		super.stepHit(step);
	}

    override public function beatHit(beat:Int) {
        super.beatHit(beat);

        _logo.scale.set(_logoBaseScale + 0.15, _logoBaseScale + 0.15);
        _logo.centerOrigin();
    }

    override public function barHit(bar:Int) {
        super.barHit(bar);

        _logo.scale.set(_logoBaseScale + 0.3, _logoBaseScale + 0.3);
        _logo.centerOrigin();
    }
}