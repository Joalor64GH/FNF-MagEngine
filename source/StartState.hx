package;

import flixel.FlxG;
import flixel.FlxState;
import openfl.Lib;

class StartState extends FlxState
{
	override public function create()
	{
		FlxG.save.bind('funkin', 'ninjamuffin99');
		PlayerSettings.init();
		MagDefaults.init();

		if (FlxG.save.data.cache){
			FlxG.switchState(new CachingState());
		}
		else
		{
		FlxG.switchState(new TitleState());
		}

		super.create();
	}
}
