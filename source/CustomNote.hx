package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
#if sys
import sys.FileSystem;
#end

class CustomNote
{
	public static var name:String;
	public static var causesMiss:Bool;
	public static var event:Null<Void>;

	public function new(name:String = "")
	{
		super();

		this.name = name;
	}
}
