package system;

import openfl.system.System;
import openfl.Assets as OpenFLAssets;
import lime.utils.Assets;
import flixel.FlxG;

class MemoryManager
{
	public static function freeTrashedAssets()
	{
		@:privateAccess
		for (asset in FlxG.bitmap._cache.keys())
		{
			if (Paths.localTrackedAssets.contains(asset) && !Paths.customImagesLoaded.exists(asset))
			{
				if (FlxG.bitmap._cache.get(asset) != null)
				{
					FlxG.bitmap._cache.remove(asset);
					FlxG.bitmap._cache.get(asset).destroy();
					OpenFLAssets.cache.removeBitmapData(asset);
				}
			}
		}
		for (sound in Paths.currentTrackedSounds.keys())
		{
			if (Paths.currentTrackedSounds.get(sound) != null && !Paths.currentTrackedSounds.exists(sound))
			{
				Assets.cache.clear(sound);
				Paths.currentTrackedSounds.remove(sound);
			}
		}
		OpenFLAssets.cache.clear();
		Paths.localTrackedAssets = [];
		System.gc();
	}

	public static function freeAllAssets(isTrans:Bool = false)
	{
		if (isTrans)
		{
			@:privateAccess
			FlxG.bitmap._cache = [];

			OpenFLAssets.cache.clear();
			Paths.localTrackedAssets = [];
			System.gc();
		}
	}
}
