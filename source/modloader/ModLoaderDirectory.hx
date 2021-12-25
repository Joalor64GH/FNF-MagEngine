package modloader;

#if polymod
import sys.io.File;
import openfl.display.BitmapData;
import flixel.FlxSprite;

using StringTools;

class ModLoaderDirectory
{
	var modId:String;

	public static var dir:String;

	function loadModLoaderDirectory()
	{
		modId = 'Template Mod';
		dir = "mods/Modloader/" + modId + "/";
	}
}
#end
