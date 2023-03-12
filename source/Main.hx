package;

import openfl.text.TextFormat;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
#if sys
import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
#end
#if CRASH_DUMPING
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import lime.app.Application;
#end
import openfl.system.System;
import states.StartState;
import system.SimpleInfoDisplay;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = StartState; // The FlxState the game starts with.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	// You can pretty much ignore everything from here on your code should go in your states.

	public static function main():Void
	{
		#if UPDATER
		var rawCommand = Sys.args();
		if (rawCommand.contains('startUpdate'))
		{
			var cleanUp:String->String->Void = null;
			cleanUp = function(curPath, newPath)
			{
				FileSystem.createDirectory(curPath);
				FileSystem.createDirectory(newPath);
				for (file in FileSystem.readDirectory(curPath))
				{
					if (FileSystem.isDirectory(curPath + "/" + file))
					{
						cleanUp(curPath + "/" + file, newPath + "/" + file);
					}
					else
					{
						File.copy(curPath + "/" + file, newPath + "/" + file);
					}
				}
			}
			cleanUp('./updateCache', '.');
			CoolUtil.deleteFolderContents('./updateCache');
			FileSystem.deleteDirectory('./updateCache');
			new Process('start /B "" "Mag Engine.exe"', null);
			System.exit(0);
		}
		else
		{
			if (FileSystem.exists("Updater.exe"))
				FileSystem.deleteFile('Updater.exe');

			Lib.current.addChild(new Main());
		}
		#else
		Lib.current.addChild(new Main());
		#end
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if html5
		framerate = 60;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		display = new SimpleInfoDisplay(10, 3, 0xFFFFFF);
		addChild(display);
		#end

		if (FlxG.save.data.fps != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);

		if (FlxG.save.data.mem != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleMem(FlxG.save.data.mem);

		if (FlxG.save.data.v != null)
			(cast(Lib.current.getChildAt(0), Main)).toggleVers(FlxG.save.data.v);

		FlxG.mouse.visible = false;

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end

		#if CRASH_DUMPING
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, programError);
		#end
	}

	public static var display:SimpleInfoDisplay;

	public function toggleFPS(enabled:Bool):Void
	{
		display.infoDisplayed[0] = enabled;
	}

	public function toggleMem(enabled:Bool):Void
	{
		display.infoDisplayed[1] = enabled;
	}

	public function toggleVers(enabled:Bool):Void
	{
		display.infoDisplayed[2] = enabled;
	}

	public static function changeFont(font:String):Void
	{
		display.defaultTextFormat = new TextFormat(font, (font == "_sans" ? 12 : 14), display.textColor);
	}

	#if CRASH_DUMPING
	public static function programError(e:UncaughtErrorEvent)
	{
		var stackTrace:Array<StackItem> = CallStack.exceptionStack(true);
		var theTime = logging.LoggingUtil.time;
		var theMessage:String = "";
		var theStackTrace:String = "";

		if (FlxG.save.data.logsAllowed)
			theMessage = '\nPlease report the issue at: https://github.com/Magnumsrt/MagEngine-Public/issues \n\nThe stack trace has been saved to:\n${Sys.getCwd()}logs/$theTime.log';
		else
			theMessage = '\nPlease report the issue at: https://github.com/Magnumsrt/MagEngine-Public/issues';

		for (item in stackTrace)
		{
			switch (item)
			{
				case CFunction:
					theStackTrace += "Called from a C Function\n";
				case Module(m):
					theStackTrace += "At module: " + m + "\n";
				case FilePos(s, file, line, column):
					if (column != null)
						theStackTrace += "Called from: " + file + ":" + line + " column: " + column + "\n";
					else
						theStackTrace += "Called from: " + file + ":" + line + "\n";
				case Method(classname, method):
					theStackTrace += "Called from method: " + method + " in class: " + classname + "\n";
				case LocalFunction(v):
					theStackTrace += "Called from a local function: " + v + "\n";
				default:
					trace(item);
			}
		}

		logging.LoggingUtil.writeToLogFile(e.error + "\n" + theStackTrace);

		theStackTrace = 'Uncaught Error | Exit Code: 1\n\n${e.error}\n\n' + theStackTrace;
		theMessage = theStackTrace + theMessage;

		Application.current.window.alert(theMessage, e.error);
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}
