package;

class MagDefaults
{
	public static function init()
	{
		Prefs.init();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
	}
}
