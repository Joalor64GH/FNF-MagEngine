package states;

import flixel.FlxG;
import flixel.FlxState;
#if CACHE
import caching.CachingState;
#end

class StartState extends FlxState
{
	override public function create()
	{
		FlxG.save.bind('funkin', 'ninjamuffin99');
		PlayerSettings.init();
		engine.MagDefaults.init();

		#if (CACHE && !debug)
		if (FlxG.save.data.cache)
			FlxG.switchState(new CachingState());
		else
			FlxG.switchState(new TitleState());
		#else
		FlxG.switchState(new TitleState());
		#end

		super.create();
	}
}
