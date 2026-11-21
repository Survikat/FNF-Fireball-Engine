package engine.objects;

import animate.FlxAnimate;
import animate.FlxAnimateFrames.FlxAnimateSettings;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;

class FBSprite extends FlxAnimate {
    public var animationOffsets:Map<String, FlxPoint>;

    private var _animOffset:FlxPoint = new FlxPoint();

    override public function new(?x:Float = 0, ?y:Float = 0, ?graphic:FlxGraphic, ?settings:FlxAnimateSettings) {
        animationOffsets = new Map();

        super(x, y, graphic, settings);
    }

    public function scaleSprite(width:Float = 0, height:Float = 0):Void {
        setGraphicSize(width, height);
        updateHitbox();
    }

    public function playAnim(name:String, ?force:Bool = false, ?reversed:Bool = false, ?frame:Int = 0):Void {
        anim.play(name, force, reversed, frame);

        var currentOffset:FlxPoint = new FlxPoint(0, 0);
        if (animationOffsets.exists(name)) {
            currentOffset = animationOffsets.get(name);
        }

        _animOffset = currentOffset;
    }

    // Pretty much copied directly from the base FlxAnimate class.
    // I wasted an hour debugging this because I accidentally set the offsets wrong and they were applying to the wrong animations.
    // This library makes me want to tear my skin off.
    override function prepareDrawMatrix(matrix:FlxMatrix, camera:FlxCamera):Void
	{
		final doStageMatrix:Bool = (isAnimate && applyStageMatrix);

		if (doStageMatrix)
		{
			matrix.translate(timeline._bounds.x, timeline._bounds.y);
		}

		matrix.translate(-origin.x, -origin.y);
		matrix.scale(scale.x, scale.y);

		if (angle != 0)
		{
			updateTrig();
			matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}

		if (skew.x != 0 || skew.y != 0)
		{
			updateSkew();
			matrix.concat(FlxAnimate._skewMatrix);
		}

		if (doStageMatrix) // TODO: add some way to customize the order of this thing
		{
			matrix.concat(library.matrix);
		}

		getScreenPosition(_point, camera);
		_point.x += (origin.x - offset.x) + _animOffset.x;
		_point.y += (origin.y - offset.y) + _animOffset.y;
		matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera))
			preparePixelPerfectMatrix(matrix);
	}
}