package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var updateVersion:String;

	override function create()
	{
		MemoryManager.freeTrashedAssets();
		MemoryManager.freeAllAssets();

		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var ver = "v" + Application.current.meta.get('version');

		var http = new haxe.Http("https://raw.githubusercontent.com/magnumsrtisswag/MagEngine-Public/main/gameVersion.txt");

		http.onData = function(data:String)
		{
			#if UPDATER
			var txt:FlxText = new FlxText(0, 0, FlxG.width,
				"Mag Engine is outdated!\nThe current version of Mag Engine is "
				+ ver
				+ " while the most recent version of Mag Engine is "
				+ "v"
				+ data
				+ "! Press SPACE to go to Github, ENTER to update in game,\nor ESCAPE to ignore this!",
				32);
			#else
			var txt:FlxText = new FlxText(0, 0, FlxG.width,
				"Mag Engine is outdated!\nThe current version of Mag Engine is "
				+ ver
				+ " while the most recent version of Mag Engine is "
				+ "v"
				+ data
				+ "! Press SPACE to go to Github, or ESCAPE to ignore this!",
				32);
			#end
			txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
			txt.screenCenter();
			add(txt);
		}

		http.request();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			CoolUtil.openURL("https://github.com/magnumsrtisswag/MagEngine-Public/releases");
		}
		#if UPDATER
		else if (FlxG.keys.justPressed.ENTER)
		{
			MusicBeatState.switchState(new UpdateState());
		}
		#end
	else if (controls.BACK)
	{
		leftState = true;
		MusicBeatState.switchState(new MainMenuState());
	}
		super.update(elapsed);
	}
}
