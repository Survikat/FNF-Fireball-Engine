package game;

import engine.states.TemplateState;

class SetupState extends TemplateState {
    override public function create() {
		super.create();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}

/**
 * Current plan:
 * - Upon first start up, game will ask for the assets from the base game. The user has the option to
 * either drag and drop a zip of the assets, drag and drop the directory, or click to select the directory/zip
 * in File Explorer.
 * - Once the assets are selected, it will copy some assets to `resources/`, to be used within the Engine.
 * It will not copy all of them. Only character assets, the fonts used, menu music, and possibly all the stages.
 * 
 * This should be the pretty much everything anyone would need to make a mod. If they want more than that, they should really just
 * use the base game's internal modding. This is just an easier and light alternative (at least, that's the plan).
 * 
 * As for the reason why it's not copied into assets, it's because `resources/` will be treated sort of like a mod? I don't know
 * how I'm going to do my implementation yet, but I feel like that would be simplest.
 * 
 * A part of me also is considering the idea of removing the entire FNF aspect and just making an open source rhythm game engine designed
 * for projects, like FNF Mods, or anything else someone gets the idea for. Just made easier. If that doesn't explain how far I want to go
 * with the ease of use of this engine, I don't think much will. I genuinely want to make it so even a dumbass could use it without even really
 * reading a wiki. I guess I'll need to decide that soon though, won't I? I probably won't.
 * 
 * I also need to seperate the assets to fall under a different license, since I want to hold ownership completely over any assets I make for this.
 * Which, it will probably only really be music. I do wonder how that would work considering PRs may contain other peoples assets in the future,
 * if I get any that is. I'll have to see if there's a license that's basically just "I own my shit, if you make shit for this then I have a license
 * to use it for this project in any way, shape, or form."... Although, I don't want or need to be able to do everything with it. Just enough to where
 * I can use it for this project and things relating to it. I don't know if something like that exists? I'm not good with licenses.
 * 
 * Gone on a bit of a tangent here, if that's even the right term. Whoops.
 */
