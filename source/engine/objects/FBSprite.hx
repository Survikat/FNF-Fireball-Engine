package engine.objects;

import animate.FlxAnimate;

class FBSprite extends FlxAnimate {
    public function scaleSprite(width:Float = 0, height:Float = 0):Void {
        setGraphicSize(width, height);
        updateHitbox();
    }
}