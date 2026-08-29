package states;

import engine.GameManager;
import engine.Resources;
import engine.objects.characters.Character;
import engine.save.Highscores;
import engine.states.MusicalState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

final class TestState extends MusicalState {
	private var _text:FlxText;

    private var _logo:FlxSprite;
    private var _bf:Character;

    private var _logoBaseScale:Float = 0.5;

    override public function create() {
		super.create();

        GameManager.playMusic(song, "Beat", true);
        
		song.play();
        song.looped = true;

        var bg:FlxSprite = new FlxSprite().loadGraphic(Resources.getGraphic("images/menuDesat"));
        bg.antialiasing = true;
        bg.color = FlxColor.ORANGE;
        bg.alpha = 0.4;
        add(bg);

        _logo = new FlxSprite().loadGraphic(Resources.getGraphic("images/logo"));
        _logo.antialiasing = true;
        _logo.updateHitbox();
        _logo.centerOrigin();
        _logo.screenCenter(XY);
        add(_logo);

        _bf = new Character("boyfriend");
        _bf.scaleSprite(_bf.width * 0.7);
        _bf.setPosition(FlxG.width - _bf.width, FlxG.height - _bf.height);
        add(_bf);

		_text = new FlxText();
		_text.size = 30;
		add(_text);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.timeScale = Math.max(0.1, song.pitch);

        if (FlxG.keys.justPressed.SPACE) {
            Highscores.setSongScore('Test${Std.int(Math.random() * 1000)}', "normal", Std.int(Math.random() * 10000));

            if (song.playing)
                song.play();
            else
                song.pause();

            _bf.play("cheer");
        }

        final elapsedLerp:Float = FlxMath.getElapsedLerp(0.4, elapsed);

        _logo.scale.x = FlxMath.lerp(_logo.scale.x, _logoBaseScale, elapsedLerp);
        _logo.scale.y = FlxMath.lerp(_logo.scale.y, _logoBaseScale, elapsedLerp);
        _logo.centerOrigin();

        _text.text =
        'curBar: ${song.curBar}\n' +
        'curBeat: ${song.curBeat}\n' +
        'curStep: ${song.curStep}\n\n' +
        '${song.timeSignature.numerator}/${song.timeSignature.denominator} @ ${song.bpm}BPM';

        if (FlxG.keys.justPressed.LEFT) {
            _bf.play("singLEFT");
        } else if (FlxG.keys.justPressed.DOWN) {
            _bf.play("singDOWN");
        } else if (FlxG.keys.justPressed.UP) {
            _bf.play("singUP");
        } else if (FlxG.keys.justPressed.RIGHT) {
            _bf.play("singRIGHT");
        }
    }

	override public function stepHit(step:Int):Void {
		super.stepHit(step);
	}

    override public function beatHit(beat:Int) {
        super.beatHit(beat);

        _logo.scale.set(_logoBaseScale + 0.15, _logoBaseScale + 0.15);
        _logo.centerOrigin();

        if (_bf.anim.finished)
            _bf.dance();
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