package states;

import engine.save.Save;
import engine.states.TemplateState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import lime.ui.FileDialog;

/**
 * Current plan:
 * - Upon first start up, game will ask for the assets from the base game. The user has the option to
 * either drag and drop a zip of the assets, drag and drop the directory, or click to select the directory/zip
 * in File Explorer.
 * - Once the assets are selected, it will copy some assets to `resources/`, to be used within the Engine.
 * It will not copy all of them. Only character assets, the fonts used, menu music, and possibly all the stages.
 */

final class SetupState extends TemplateState {
	private var _fileExplorerButt:FlxSpriteButton;
	private var _textNotice:FlxText;

	private var _dialog:FileDialog;

	private var _working:Bool = false;
	private var _assetPath:String;

    override public function create() {
		super.create();

		_dialog = new FileDialog();

		#if debug
		_dialog.onCancel.add(() -> {
			trace('File selection dialog cancelled.');
		});
		#end

		_dialog.onSelect.add((path) -> {
			_working = true;

			trace(path);

			Save.set("initialized", true);
			FlxG.resetGame();
		});

		this.camera.bgColor = FlxColor.GRAY;

		_fileExplorerButt = new FlxSpriteButton(0, 0, null, () -> {
			if (!_working) {
				_dialog.browse(
					OPEN_DIRECTORY,
					null,
					null,
					"Select directory"
				);
			}
		});

		_fileExplorerButt.loadGraphic("images/ui/setup/folderIconButt", true, 32, 32);

		_fileExplorerButt.scale.set(4, 4);
		_fileExplorerButt.updateHitbox();
		_fileExplorerButt.screenCenter(XY);

		_fileExplorerButt.animation.add("idle", [0], 1 , true);
		_fileExplorerButt.animation.add("hover", [1], 1, false);

		_textNotice = new FlxText();
		_textNotice.y = _fileExplorerButt.y + _fileExplorerButt.height + 12;

		_textNotice.text = "Click to enable Fireball Engine.\n(select the Friday Night Funkin' directory)";

		_textNotice.setFormat(null, 12, FlxColor.BLACK, CENTER);
		_textNotice.screenCenter(X);

		add(_textNotice);
		add(_fileExplorerButt);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.overlaps(_fileExplorerButt, _fileExplorerButt.camera)) {
			_fileExplorerButt.animation.play("hover");
		} else {
			_fileExplorerButt.animation.play("idle");
		}
	}
}