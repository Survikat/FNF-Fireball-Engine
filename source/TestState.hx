package;

import engine.GameManager;
import engine.Resources;
import engine.save.Highscores;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TestState extends MusicalState {
	private var _text:FlxText;

    private var _logo:FlxSprite;
    private var _logoBaseScale:Float = 0.5;

    override public function create() {
		super.create();

        GameManager.playMusic(song, "Beat", true);
        
		song.play();
        song.looped = true;

        _logo = new FlxSprite().loadGraphic(Resources.getGraphic("images/logo"));
        _logo.antialiasing = true;
        _logo.updateHitbox();
        _logo.centerOrigin();
        _logo.screenCenter(XY);
        add(_logo);

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.timeScale = Math.max(song.pitch, 0.5);

        if (FlxG.keys.justPressed.SPACE) {
            Highscores.setSongScore('Test${Std.int(Math.random() * 1000)}', "normal", Std.int(Math.random() * 10000));

            if (song.playing)
                song.play();
            else
                song.pause();
        } else {
            if (FlxG.keys.pressed.LEFT)
                song.time -= 2.5 * FlxG.elapsed;
            else if (FlxG.keys.pressed.RIGHT)
                song.time += 2.5 * FlxG.elapsed;

            if (FlxG.keys.pressed.UP)
                song.pitch = Math.max(FlxMath.roundDecimal(song.pitch + (1 * FlxG.elapsed), 2), 0.5);
            else if (FlxG.keys.pressed.DOWN)
                song.pitch = Math.max(FlxMath.roundDecimal(song.pitch - (1 * FlxG.elapsed), 2), 0.5);
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

    private var _flipDir:Float = 1;
    override public function barHit(bar:Int) {
        super.barHit(bar);

        if (bar > 0) {
            _logo.scale.set(_logoBaseScale + 0.3, _logoBaseScale + 0.3);
            _logo.centerOrigin();

            FlxTween.tween(_logo, {angle: 360 * _flipDir}, song.beatDuration * 2, {onComplete: (t) -> {
                _logo.angle = 0;
                _flipDir = -_flipDir;
            }, ease: FlxEase.quartOut});
        }
    }

    override public function destroy() {
        super.destroy();

        FlxG.timeScale = 1;
    }
}