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

class Resources {
    private static final _defResourceDirs:Array<String> = ["assets", "resources"];
    
    private static var _modResourceDirectories:Array<String> = [];
    private static var _resourceDirectories:Array<String> = _defResourceDirs.copy();

    /**
     * Adds a resource directory.
     * @param path Path of directory.
     */
    public static function addDir(path:String):Void {
        _resourceDirectories = _modResourceDirectories.copy();

        if (!_resourceDirectories.contains(path)) {
            _resourceDirectories.push(path);
        }
        
        // Put default directories last in the list
        for (dir in _defResourceDirs)
            _resourceDirectories.push(dir);
    }

    /**
     * Removes a resource directory.
     * @param path Path of directory.
     */
    public static function delDir(path:String):Void {
        if (_defResourceDirs.contains(path)) {
            trace('Cannot remove default resource directory.');
            return;
        }

        if (_modResourceDirectories.contains(path))
            _modResourceDirectories.remove(path);

        _resourceDirectories.remove(path);
    }

    /**
     * Set the default resource directory (first directory to check).
     * @param path Path of directory.
     */
    public static function setDefault(path:String):Void {
        if (!_resourceDirectories.contains(path)) {
            trace('Directory is not defined, cannot set as default.');
            return;
        }

        var resIndex:Int = _resourceDirectories.indexOf(path);
        var prevDefRes:String = _resourceDirectories[0];

        _resourceDirectories[0] = path;
        _resourceDirectories[resIndex] = prevDefRes;
    }

    public static function getContent(path:String):String { 
        for (dir in _resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path');

            if (assetExists(finalPath)) {
                return File.getFileText(finalPath);
            }
        }

        return null;
    }

    public static function getBinary(path:String):Bytes { 
        for (dir in _resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path');

            if (assetExists(finalPath)) {
                return File.getFileBytes(finalPath);
            }
        }

        return null;
    }

    public static function getSound(path:String):FlxSoundAsset {
        for (dir in _resourceDirectories) {
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

    public static function getGraphic(path):FlxGraphic {
        for (dir in _resourceDirectories) {
            final finalPath:String = Path.normalize('$dir/$path.png');

            if (assetExists(finalPath)) {
                var bitmap:BitmapData;

                if (Assets.cache.hasBitmapData(finalPath)) {
                    bitmap = Assets.cache.getBitmapData(finalPath);
                } else {
                    bitmap = BitmapData.fromFile(finalPath);
                    Assets.cache.setBitmapData(finalPath, bitmap);
                }

                final targetGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap);
                targetGraphic.persist = true;

                return targetGraphic;
            }
        }

        return null;
    }

    public static function assetExists(path:String):Bool {
        var exists:Bool = FlxG.assets.exists(path) || FileSystem.exists(path);
        return exists;
    }
}