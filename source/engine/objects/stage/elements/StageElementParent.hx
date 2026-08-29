package engine.objects.stage.elements;

import animate.FlxAnimateFrames.FlxAnimateSettings;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Exactly like a FBSpriteParent, but with StageElements.
 */
class StageElementParent extends StageElement {
    public var children:FlxTypedGroup<StageElement>;

    override public function new(?maxSize:Int = 0, ?x:Float = 0, ?y:Float = 0, ?graphic:FlxGraphic, settings:FlxAnimateSettings) {
        super(x, y, graphic, settings);
        children = new FlxTypedGroup(maxSize);
    }

    override public function draw():Void {
        super.draw();

        children.cameras = this.cameras;
        if (visible)
            children.draw();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (active)
            children.update(elapsed);
    }

    public function add(child:StageElement):Void
        children.add(child);
    public function remove(child:StageElement):Void
        children.remove(child);

    override public function onBar(bar:Int):Void {
        forEachAlive((element) -> {
            element.onBar(bar);
        });
    }

    override public function onBeat(beat:Int):Void {
        forEachAlive((element) -> {
            element.onBeat(beat);
        });
    }

    override public function onStep(step:Int):Void {
        forEachAlive((element) -> {
            element.onStep(step);
        });
    }

	public function forEach(func:StageElement->Void, ?recurse = false)
        children.forEach(func, recurse);

	public function forEachAlive(func:StageElement->Void, ?recurse = false)
        children.forEachAlive(func, recurse);

	public function forEachDead(func:StageElement->Void, ?recurse = false)
        children.forEachDead(func, recurse);

	public function forEachExists(func:StageElement->Void, ?recurse:Bool = false)
        children.forEachExists(func, recurse);
}