package states.game;

import engine.GameManager;
import engine.Resources;
import engine.objects.FBSprite;
import engine.objects.characters.Character;
import engine.states.templates.MusicalState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxColor;

final class PlayState extends MusicalState {
    private final _res:FlxPoint = new FlxPoint(1280, 720);

    private var _inst:FlxSound;
    private var _mainVocals:FlxSound;
    private var _opponentVocals:FlxSound;

    private var _gameCam:FlxCamera;
    private var _hudCam:FlxCamera;

    private var _player:Character;
    private var _dancer:Character;
    private var _opponent:Character;

    override public function create():Void {
        _gameCam = new FlxCamera(FlxG.width - _res.x, FlxG.height - _res.y, Std.int(_res.x), Std.int(_res.y));

        _hudCam = new FlxCamera();
        _hudCam.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(_gameCam, true);
        FlxG.cameras.add(_hudCam, false);

        super.create();

        final instOnly:Bool = true;
        final tracks = GameManager.playMusic(song, "Beat", instOnly);

        _inst = tracks.get(Instrumental);

        if (!instOnly) {
            _mainVocals = tracks.get(Player);
            _opponentVocals = tracks.get(Opponent);

            if (_mainVocals == null || _opponentVocals == null)
                _mainVocals = tracks.get(Duet);
        }

        var bg:FBSprite = new FBSprite(0, 0, Resources.getGraphic("images/menuDesat"));
        bg.scaleSprite(FlxG.width, FlxG.height);
        bg.antialiasing = true;
        bg.color = FlxColor.ORANGE;
        add(bg);

        _player = new Character("boyfriend");
        _player.scaleSprite(_player.width * 0.7);
        _player.setPosition((FlxG.width - _player.width) - 24, (FlxG.height - _player.height) - 24);

        _dancer = new Character("boyfriend");
        _dancer.scaleSprite(_dancer.width * 0.7);
        _dancer.screenCenter();

        _opponent = new Character("boyfriend");
        _opponent.scaleSprite(_opponent.width * 0.7);
        _opponent.setPosition(24, (FlxG.height - _player.height) - 24);
        _opponent.flipX = true;

        add(_opponent);
        add(_dancer);
        add(_player);

        song.play();
    }

    override public function update(elapsed:Float):Void {
        final elapsedLerp:Float = FlxMath.getElapsedLerp(0.2, elapsed);

        super.update(elapsed);

        _gameCam.zoom = FlxMath.lerp(_gameCam.zoom, 1, elapsedLerp);
        _hudCam.zoom = FlxMath.lerp(_hudCam.zoom, 1, elapsedLerp);
    }

    override public function beatHit(beat:Int):Void {
        super.beatHit(beat);

        _player.dance();
        _dancer.dance();
        _opponent.dance();
    }

    private var _lastDancerTween:VarTween; // I like rotating
    override public function barHit(bar:Int):Void {
        super.barHit(bar);

        if (_lastDancerTween != null && !_lastDancerTween.finished) {
            _lastDancerTween.onComplete(_lastDancerTween);
            _lastDancerTween.cancel();
        }

        _lastDancerTween = FlxTween.tween(_dancer, {angle: 360}, song.barDuration, {onComplete: (tween) -> {
            _dancer.angle = 0;
            _dancer.flipX = !_dancer.flipX;
        }});

        _gameCam.zoom += 0.15;
        _hudCam.zoom += 0.05;
    }
}