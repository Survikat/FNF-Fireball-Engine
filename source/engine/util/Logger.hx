package engine.util;

// I plan on redoing this later.

/*import flixel.FlxG;
import haxe.Log;
import haxe.Timer;
import lime.system.System;
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
        #if (target.threaded && desktop)
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
        File.saveContent(_path, '${Main.engineName} v${Main.version} - ${System.platformName} (${System.platformVersion}) - ${date.toString()}\n\n');

        Thread.createWithEventLoop(() -> {
            var content:String = null;

            var saveTimer:Timer = new Timer(250);
            saveTimer.run = () -> {
                if (_changes.length > 0) {
                    var changes:Array<String> = _changes.copy();

                    if (FileSystem.exists(_path)) {
                        try {
                            content = File.getContent(_path);
                        } catch (e:Dynamic) {
                            Sys.println('Failed to get previous log! ($e).');
                        }
                    } else {
                        content = "Failed to get previous log, previous content does not exist.\n\n";
                    }

                    for (change in changes) {
                        content += change;
                        _changes.remove(change);
                    }

                    try { File.saveContent(_path, content); } catch(e:Dynamic) { Sys.println('Failed to save log ($e).'); }

                    content = null;
                    changes = null;
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

        #if (!target.threaded && desktop)
        final oldContent:String = File.getContent(_path);
        File.saveContent(_path, oldContent + output);
        #else
        _changes.push(output);
        #end

        #if (debug || !target.threaded)
        Sys.println(output.trim());
        #end
    }
}*/