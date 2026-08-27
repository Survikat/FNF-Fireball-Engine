package api;

import haxe.Timer;

#if desktop
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

final class DiscordAPI {
    public static function Init():Void {
        final handlers:DiscordEventHandlers = new DiscordEventHandlers();

		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);

		Discord.Initialize("1542526698166165654", cpp.RawPointer.addressOf(handlers), false, null);

		var updateTimer:Timer = new Timer(500);
		updateTimer.run = () -> {
			Discord.RunCallbacks();
		}
    }

    private static function onReady(request:cpp.RawConstPointer<DiscordUser>):Void
	{
		final username:String = request[0].username;
		trace('Connected to user @${username}.');

		setPresence("", "", "icon");
	}

	private static function onDisconnected(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Disconnected ($errorCode:$message).');
	}

	private static function onError(errorCode:Int, message:cpp.ConstCharStar):Void
	{
		trace('Error ($errorCode:$message).');
	}

    public static function setPresence(state:String, details:String, largeImageKey:String, ?smallImageKey:String = ""):Void {
		final presence = new DiscordRichPresence();
        presence.type = DiscordActivityType_Playing;

        presence.state = state;
        presence.details = details;
        presence.largeImageKey = largeImageKey;
        presence.smallImageKey = smallImageKey;

        Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
    }
}
#end