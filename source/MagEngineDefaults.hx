import openfl.Lib;
import flixel.FlxG;

class MagEngineDefaults
{
    public static function initSave()
    {
     	if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;

		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = false;

		if (FlxG.save.data.accuracy == null)
			FlxG.save.data.accuracy = false;

		if (FlxG.save.data.splooshes == null)
			FlxG.save.data.splooshes = true;

		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;

		if (FlxG.save.data.mem == null)
			FlxG.save.data.mem = true;

		if (FlxG.save.data.v == null)
			FlxG.save.data.v = true;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 60;
		
		if (FlxG.save.data.modList == null)
			FlxG.save.data.modList = true;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = false;

		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
        
	}
}