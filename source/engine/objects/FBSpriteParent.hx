package engine.objects;

import animate.FlxAnimateFrames.FlxAnimateSettings;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * Essentially an FlxTypedGroup of an FBSprite, but can also behave as a sprite.
 * Allows for the ability to make groups within elements that can strictly only hold an FBSprite.
 * 
 * FBSpriteParent's do not drastically control or manipulate the children contained within it,
 * it will only affect whether or not the children are visible or active, as well as what it renders to.
 */
class FBSpriteParent extends FBSprite {
    public var children:FlxTypedGroup<FBSprite>;

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

    public function add(child:FBSprite):Void
        children.add(child);
    public function remove(child:FBSprite):Void
        children.remove(child);

	public function forEach(func:FBSprite->Void, ?recurse = false)
        children.forEach(func, recurse);

	public function forEachAlive(func:FBSprite->Void, ?recurse = false)
        children.forEachAlive(func, recurse);

	public function forEachDead(func:FBSprite->Void, ?recurse = false)
        children.forEachDead(func, recurse);

	public function forEachExists(func:FBSprite->Void, ?recurse:Bool = false)
        children.forEachExists(func, recurse);
}