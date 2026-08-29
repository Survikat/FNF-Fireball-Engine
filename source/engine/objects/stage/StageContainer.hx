package engine.objects.stage;

import engine.objects.stage.elements.StageElement;
import flixel.group.FlxContainer;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;

class StageContainer extends FlxContainer {
    public var characterLayer:FlxGroup;
    public var dancerLayer:FlxGroup; // Background Dancers / Girlfriend

    private var _bgStageLayer:FlxTypedSpriteContainer<StageElement>; // Background
    private var _mgStageLayer:FlxTypedSpriteContainer<StageElement>; // Middleground
    private var _fgStageLayer:FlxTypedSpriteContainer<StageElement>; // Foreground

    override public function new() {
        super();

        _bgStageLayer = new FlxTypedSpriteContainer();
        _fgStageLayer = new FlxTypedSpriteContainer();

        characterLayer = new FlxGroup();

        // Build stage here

        add(_bgStageLayer);
        add(dancerLayer);
        add(_mgStageLayer);
        add(characterLayer);
        add(_fgStageLayer);
    }

    public function onBar(bar:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onBar(bar); });
        _mgStageLayer.forEachAlive((element) -> { element.onBar(bar); });
        _fgStageLayer.forEachAlive((element) -> { element.onBar(bar); });
    }

    public function onBeat(beat:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onBeat(beat); });
        _mgStageLayer.forEachAlive((element) -> { element.onBeat(beat); });
        _fgStageLayer.forEachAlive((element) -> { element.onBeat(beat); });
    }

    public function onStep(step:Int):Void {
        _bgStageLayer.forEachAlive((element) -> { element.onStep(step); });
        _mgStageLayer.forEachAlive((element) -> { element.onStep(step); });
        _fgStageLayer.forEachAlive((element) -> { element.onStep(step); });
    }
}