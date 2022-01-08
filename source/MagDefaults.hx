import flixel.FlxG;

class MagDefaults
{
	public static function init()
	{
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.ghostTapping == null)
			FlxG.save.data.ghostTapping = true;

		if (FlxG.save.data.accuracy == null)
			FlxG.save.data.accuracy = true;

		if (FlxG.save.data.splooshes == null)
			FlxG.save.data.splooshes = true;

		if (FlxG.save.data.transparentNotes == null)
			FlxG.save.data.transparentNotes = false;

		if (FlxG.save.data.cache == null)
			FlxG.save.data.cache = true;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;

		if (FlxG.save.data.mem == null)
			FlxG.save.data.mem = true;

		if (FlxG.save.data.v == null)
			FlxG.save.data.v = true;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 60;

		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
	}
}
