package states;

import engine.Resources;
import engine.save.Save;
import engine.states.FBState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.io.Path;
import lime.system.System;
import lime.ui.FileDialog;
import sys.FileSystem;
import sys.io.File;

using StringTools;

final class SetupState extends FBState {
	private var _fileExplorerButt:FlxSpriteButton;
	private var _textNotice:FlxText;

	private var _dialog:FileDialog;

    override public function create() {
		super.create();

		_dialog = new FileDialog();

		#if debug
		_dialog.onCancel.add(() -> {
			trace('File selection dialog cancelled.');
		});
		#end

		_dialog.onSelect.add((path) -> {
			var fixedPath:String = Path.removeTrailingSlashes(Path.normalize(path));
			if (fixedPath.endsWith('assets'))
				fixedPath = Path.normalize(fixedPath.replace('assets', ''));

			final success:Bool = SetupHelper.copyAssets(fixedPath);

			if (success) {
				Save.set("initialized", true);
				Save.set("resourceVersion", Main.resourceVersion);

				FlxG.resetGame();
			}
		});

		this.camera.bgColor = FlxColor.GRAY;

		_fileExplorerButt = new FlxSpriteButton(0, 0, null, () -> {
			_dialog.browse(
				OPEN_DIRECTORY,
				null,
				null,
				"Select directory"
			);
		});

		_fileExplorerButt.loadGraphic(Resources.getGraphic("images/ui/setup/folderButton"), true, 32, 32);

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

final class SetupHelper {
	public static function copyAssets(rootDir:String):Bool {
		final assetMapTxt:String = FlxG.assets.getText("assets/data/assetMap.txt");
		var assetsToPull:Array<String> = [];

		if (assetMapTxt == null)
			return false;

		try {
			assetsToPull = assetMapTxt.split("\n");
			for (str in assetsToPull.copy()) {
				if (str.startsWith("#") || str.startsWith('\n') || str.length <= 3) {
					assetsToPull.remove(str);
				}
			}

			for (assetCode in assetsToPull) {
				final asset:Array<String> = assetCode.split("->");

				final source:String = Path.normalize('$rootDir/${asset[0].replace('"', '').trim()}');
				final dest:String = Path.normalize('${System.applicationDirectory}/${asset[1].replace('"', '').trim()}');

				FileSystem.createDirectory(Path.directory(dest));

				if (FileSystem.exists(source) && !FileSystem.isDirectory(source)) {
					trace('[FILE] "$source"->"$dest"');
					File.saveBytes(dest, File.getBytes(source)); // File.copy() doesn't work for some reason.
				} else if (FileSystem.isDirectory(source)) {
					trace('Copying assets from "${source}".');

					for (file in FileSystem.readDirectory(source)) {
						final subFileSource:String = Path.normalize('$source/${Path.withoutDirectory(file)}'.trim());
						final subFileDest:String = Path.normalize('$dest/${Path.withoutDirectory(file)}'.trim());

						FileSystem.createDirectory(Path.directory(subFileDest));

						if (FileSystem.exists(subFileSource) && !FileSystem.isDirectory(subFileSource)) {
							trace('[DIR] "$subFileSource"->"$subFileDest"');
							File.saveBytes(subFileDest, File.getBytes(subFileSource));
						} else if (FileSystem.isDirectory(subFileSource)) {
							trace("Sub-directories cannot be copied!");
						} else {
							trace("Failed to copy asset within a directory.");
							return false;
						}
					}
				} else {
					trace('Source asset "$source" does not exist!');
					return false;
				}
			}

		} catch(e:Dynamic) {
			trace('Failed to copy over assets! ($e)');
			return false;
		}

		return true;
	}
}