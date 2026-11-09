package engine.objects.stage;

import engine.objects.stage.elements.StageElement;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class StageContainer extends FlxContainer {
    public var opponentLayer:FlxGroup;
    public var playerLayer:FlxGroup;
    public var dancerLayer:FlxGroup; // Background Dancers / Girlfriend

    private var _bgStageLayer:FlxTypedSpriteContainer<StageElement>; // Background
    private var _mgStageLayerA:FlxTypedSpriteContainer<StageElement>; // Middleground A
    private var _mgStageLayerB:FlxTypedSpriteContainer<StageElement>; // Middleground B
    private var _fgStageLayer:FlxTypedSpriteContainer<StageElement>; // Foreground

    /**
     * @param swapCharacterLayering if toggled, the player rendering will occur below the opponent rather than vice-versa.
     */
    override public function new(?swapCharacterLayering:Bool = false) {
        super();

        _bgStageLayer = new FlxTypedSpriteContainer();
        _mgStageLayerA = new FlxTypedSpriteContainer();
        _mgStageLayerB = new FlxTypedSpriteContainer();
        _fgStageLayer = new FlxTypedSpriteContainer();

        opponentLayer = new FlxGroup();
        playerLayer = new FlxGroup();

        add(_bgStageLayer);
        add(dancerLayer);
        add(_mgStageLayerA);

        if (!swapCharacterLayering) {
            add(opponentLayer);
            add(_mgStageLayerB);
            add(playerLayer);
        } else {
            add(playerLayer); 
            add(_mgStageLayerB);
            add(opponentLayer);
        }
        
        add(_fgStageLayer);
    }

    public function onBar(bar:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onBar(bar); });
        _mgStageLayerA.forEachAlive((element) -> { element.onBar(bar); });
        _mgStageLayerB.forEachAlive((element) -> { element.onBar(bar); });
        _fgStageLayer.forEachAlive((element) -> { element.onBar(bar); });
    }

    public function onBeat(beat:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onBeat(beat); });
        _mgStageLayerA.forEachAlive((element) -> { element.onBeat(beat); });
        _mgStageLayerB.forEachAlive((element) -> { element.onBeat(beat); });
        _fgStageLayer.forEachAlive((element) -> { element.onBeat(beat); });
    }

    public function onStep(step:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onStep(step); });
        _mgStageLayerA.forEachAlive((element) -> { element.onStep(step); });
        _mgStageLayerB.forEachAlive((element) -> { element.onStep(step); });
        _fgStageLayer.forEachAlive((element) -> { element.onStep(step); });
    }
}