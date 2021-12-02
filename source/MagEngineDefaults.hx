import openfl.Lib;
import flixel.FlxG;

class CableEngineData
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

		if (FlxG.save.data.modchart == null)
			FlxG.save.data.modchart = true;

		if (FlxG.save.data.splooshes == null)
			FlxG.save.data.splooshes = true;

		Conductor.recalculateTimings();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
        
	}
}