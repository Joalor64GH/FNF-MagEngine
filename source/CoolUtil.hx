package;

import flixel.FlxG;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static var difficultyStuff:Array<Dynamic> = [['Easy'], ['Normal'], ['Hard']];

	public static function difficultyString(uppercase:Bool = true):String
	{
		if (uppercase)
			return difficultyStuff[PlayState.storyDifficulty][0].toUpperCase();
		else
			return difficultyStuff[PlayState.storyDifficulty][0];
	}

	public static function openURL(url:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [url]);
		#else
		FlxG.openURL(url);
		#end
	}

	// code used in psych engine
	public static function boundTo(value:Float, min:Float, max:Float):Float
	{
		var newValue:Float = value;
		if (newValue < min)
			newValue = min;
		else if (newValue > max)
			newValue = max;
		return newValue;
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function evenCoolerTextFile(path:String):Array<String>
	{
		#if MODS
		var daList:Array<String> = sys.io.File.getContent(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
		#else
		return [];
		#end
	}

	public static function coolOptions(path:String):Array<String>
	{
		var daList:Array<String> = path.trim().split('\n');

		for (i in 0...daList.length)
		{
			#if sys
			var daList:Array<String> = sys.io.File.getContent(path).trim().split('\n');

			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
			#end
			return daList;
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
}
