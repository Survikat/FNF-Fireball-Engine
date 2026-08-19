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
 */