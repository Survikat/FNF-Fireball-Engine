package engine.states;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class FBState extends FlxUIState {
    override public function new() {
        if (FlxTransitionableState.defaultTransIn == null || FlxTransitionableState.defaultTransOut == null) {
            final diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
            diamond.persist = true;

            final tileData:TransitionTileData = {
                asset: diamond,
                width: 32,
                height: 32
            }

            final rect:FlxRect = new FlxRect(-FlxG.width, -FlxG.height, FlxG.width * 2, FlxG.height * 2);

            FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, -1), tileData, rect);
            FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, 1), tileData, rect);
        }

        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;

        super();
    }
}