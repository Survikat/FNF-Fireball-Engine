package engine;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxSoundAsset;
import haxe.io.Bytes;
import haxe.io.Path;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.filesystem.File;
import openfl.media.Sound;
import sys.FileSystem;

using StringTools;

final class Resources {
    private static final _defResourceDirs:Array<String> = ["assets", "resources"];
    private static var _modResourceDirectories:Array<String> = [];

    public static var resourceDirectories(get, never):Array<String>;
    public static function get_resourceDirectories():Array<String> {
        var resDirs:Array<String> = [];

        for (mod in _modResourceDirectories)
            resDirs.push(mod);
        for (def in _defResourceDirs)
            resDirs.push(def);

        return resDirs;
    }

    /**
     * Adds a resource directory.
     * @param path Path of directory.
     */
    public static function addDir(path:String):Void {
        _modResourceDirectories.push(path);
    }

    /**
     * Removes a resource directory.
     * @param path Path of directory.
     */
    public static function rmvDir(path:String):Void {
        _modResourceDirectories.remove(path);
    }

    /**
     * Sets a default resource directory by swapping.
     * @param path 
    */
    public static function defDir(path:String):Void {
        if (!_modResourceDirectories.contains(path)) {
            if (_defResourceDirs.contains(path)) {
                trace("You can't set a default directory as the default path!");
                return;
            }

            trace('Resource directory "$path" does not exist! Did you make sure to add it first?');
            return;
        }

        final oldDefault:String = _modResourceDirectories[0];
        final indexOfPath:Int = _modResourceDirectories.indexOf(path);

        _modResourceDirectories[0] = path;
        _modResourceDirectories[indexOfPath] = oldDefault;
    }

    public static function getContent(path:String):String { 
        for (dir in resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path');

            if (assetExists(finalPath)) {
                return File.getFileText(finalPath);
            }
        }

        return null;
    }

    public static function getBinary(path:String):Bytes { 
        for (dir in resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path');

            if (assetExists(finalPath)) {
                return File.getFileBytes(finalPath);
            }
        }

        return null;
    }

    public static function getSound(path:String):FlxSoundAsset {
        for (dir in resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path.ogg');

            if (assetExists(finalPath)) {
                if (Assets.cache.hasSound(finalPath))
                    return Assets.cache.getSound(finalPath);

                final targetSound:Sound = Sound.fromFile(finalPath);

                Assets.cache.setSound(finalPath, targetSound);
                return targetSound;
            }
        }

        return null;
    }

    public static function getGraphic(path:String):FlxGraphic {
        for (dir in resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path.png');

            if (assetExists(finalPath)) {
                if (!Assets.cache.hasBitmapData(finalPath)) {
                    var bitmap:BitmapData = BitmapData.fromFile(finalPath);
                    Assets.cache.setBitmapData(finalPath, bitmap);
                }

                var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.cache.getBitmapData(finalPath), false, finalPath);
                // graphic.persist = true;

                return graphic;
            }
        }

        return null;
    }

    public static function getPath(path:String):String {
        for (dir in resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path');

            if (assetExists(finalPath) || FileSystem.isDirectory(finalPath)) {
                return finalPath;
            }
        }

        return null;
    }

    public static function assetExists(path:String):Bool {
        var exists:Bool = FlxG.assets.exists(path) || FileSystem.exists(path);
        return exists;
    }
}