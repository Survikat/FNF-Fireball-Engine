package engine;

import flixel.FlxG;
import haxe.Log;
import haxe.Timer;
import openfl.Lib;
import sys.FileSystem;
import sys.io.File;

using StringTools;

#if (target.threaded)
import sys.thread.Thread;
#end

final class Logger {
    private static var _path:String;
    private static var _changes:Array<String> = [];

    public static function init():Void {
        FileSystem.createDirectory("logs");
        final date:Date = Date.now();

        final dateStr:String = '${date.getDay()}-${date.getMonth()}-${date.getFullYear()}';
        final timeStr:String = '${date.getHours()}${date.getMinutes()}${date.getSeconds()}';

        final filePrefix:String = '${dateStr}_${timeStr}';

        var fileName:String = '$filePrefix.txt';

        // Doubt this would ever occur.
        while (FileSystem.exists('logs/$fileName')) {
            fileName = '$filePrefix-${FlxG.random.int()}.txt';
        }

        _path = 'logs/$fileName';
        File.saveContent(_path, '${Main.engineName} v${Main.version} - ${date.toString()}\n\n');

        #if (target.threaded)
        Thread.createWithEventLoop(() -> {
            var saveTimer:Timer = new Timer(250);
            saveTimer.run = () -> {
                if (_changes.length > 0) {
                    final changes:Array<String> = _changes.copy();
                    final oldContent:String = File.getContent(_path);

                    for (change in changes) {
                        #if debug
                        Sys.println(change.trim());
                        #end

                        File.saveContent(_path, oldContent + change);
                        _changes.shift();
                    }
                }
            }
        });
        #end

        Log.trace = log;
    }

    private static function log(v:Dynamic, ?infos:Null<haxe.PosInfos>):Void {
        final log:String = File.getContent(_path);
        if (log == null)
            return;

        final output:String = '${infos.fileName}:${infos.lineNumber}: $v\n';

        #if !(target.threaded)
        final oldContent:String = File.getContent(_path);
        File.saveContent(_path, oldContent + outputoutput);
        #else
        _changes.push(output);
        #end

        #if (!(target.threaded) && debug)
        Sys.println(output.trim());
        #end
    }
}