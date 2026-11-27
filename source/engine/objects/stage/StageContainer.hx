package engine.objects.stage;

import engine.objects.stage.StageElement;
import flixel.FlxSprite;
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

    override public function new(?swapCharacterLayering:Bool = false) {
        super();

        _bgStageLayer = new FlxTypedSpriteContainer();
        _mgStageLayerA = new FlxTypedSpriteContainer();
        _mgStageLayerB = new FlxTypedSpriteContainer();
        _fgStageLayer = new FlxTypedSpriteContainer();

        opponentLayer = new FlxGroup();
        playerLayer = new FlxGroup();

        regroupContainer(swapCharacterLayering);
    }

    /**
     * Kills all layers then re-adds them to the container, used for changing how characters are layered.
     * 
     * @param swapCharacterLayering if toggled, the player rendering will occur below the opponent rather than vice-versa.
     */
    public function regroupContainer(?swapCharacterLayering:Bool = false):Void {
        var _stageLayers:Array<FlxTypedSpriteContainer<StageElement>> = [
            _bgStageLayer,
            _mgStageLayerA,
            _mgStageLayerB,
            _fgStageLayer
        ];

        for (layer in _stageLayers) {
            if (layer != null && layer.alive) {
                layer.kill();
            }
        }

        if (opponentLayer != null && opponentLayer.alive)
            opponentLayer.kill();
        if (playerLayer != null && playerLayer.alive)
            playerLayer.kill();

        // Add layers
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

    public function addAsElement(object:FBSprite, container:FlxTypedSpriteContainer<StageElement>):StageElement {
        var convertedObject:StageElement = null;

        if (object is FBSprite) {
            convertedObject = cast(object, StageElement);
            container.add(convertedObject);
        } else {
            trace('Object is not valid. Is object even an FBSprite?');
        }

        return convertedObject;
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