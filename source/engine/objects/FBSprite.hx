package engine.objects;

import animate.FlxAnimate;
import animate.FlxAnimateFrames.FlxAnimateSettings;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;

class FBSprite extends FlxAnimate {
    public var animationOffsets:Map<String, FlxPoint>;

    override public function new(?x:Float = 0, ?y:Float = 0, ?graphic:FlxGraphic, ?settings:FlxAnimateSettings) {
        animationOffsets = new Map();

        super(x, y, graphic, settings);
    }

    public function scaleSprite(width:Float = 0, height:Float = 0):Void {
        setGraphicSize(width, height);
        updateHitbox();
    }

    // We have to handle offsets like this because FlxAnimate does some shenanigans with it.
    public function playAnim(name:String, ?force:Bool = false, ?reversed:Bool = false, ?frame:Int = 0):Void {
        if (anim.curAnim != null) {
            var prevOffset:FlxPoint;

            if (animationOffsets.exists(anim.curAnim.name)) {
                prevOffset = animationOffsets.get(anim.curAnim.name);
            } else {
                prevOffset = new FlxPoint();
            }

            offset.x -= prevOffset.x;
            offset.y -= prevOffset.y;
        }

        anim.play(name, force, reversed, frame);

        var animOffset:FlxPoint;

        if (animationOffsets.exists(name)) {
            animOffset = animationOffsets.get(name);
        } else {
            animOffset = new FlxPoint();
        }
        
        offset.x += animOffset.x;
        offset.y += animOffset.y;
    }
}