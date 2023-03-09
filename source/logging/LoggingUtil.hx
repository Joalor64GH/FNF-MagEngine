package logging;

import flixel.FlxG;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class LoggingUtil extends MusicBeatState
{
	public static var currentLog:String = "";
	public static var contentsArray:Array<String> = [];
	public static var time:Float = 0;

	public static function makeLogFile()
	{
		#if LOGS
		if (FlxG.save.data.logsAllowed)
		{
			time = Sys.time();
			File.write('logs/' + time + '.log', false);
			currentLog = 'logs/' + time + '.log';
		}
		#end
	}

	public static function writeToLogFile(message:String)
	{
		#if LOGS
		if (FlxG.save.data.logsAllowed)
		{
			contentsArray.push("[" + Date.now() + "] " + message);
			if (currentLog == "")
				makeLogFile();

			File.saveContent(currentLog, contentsArray.join("\n") + "\n");
		}
		#end
	}
}
