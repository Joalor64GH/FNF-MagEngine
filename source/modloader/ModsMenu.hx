package modloader;

#if sys
import modloader.ModList;
import modloader.PolymodHandler;
import modloader.ModsMenuOption;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class ModsMenu extends MusicBeatState
{
	var curSelected:Int = 0;

	public var page:FlxTypedGroup<ModsMenuOption> = new FlxTypedGroup<ModsMenuOption>();

	public static var instance:ModsMenu;

	public static var coolId:String;

	override function create()
	{
		instance = this;

		var menuBG:FlxSprite;

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));

		menuBG.color = FlxColor.PURPLE;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		super.create();

		PolymodHandler.loadModMetadata();
		
		add(page);

		loadMods();
		FlxG.mouse.visible = true;
	}

	function loadMods()
	{
		page.forEachExists(function(option:ModsMenuOption)
		{
			page.remove(option);
			option.kill();
			option.destroy();
		});

		var optionLoopNum:Int = 0;

		for(modId in PolymodHandler.metadataArrays)
			{
				var modOption = new ModsMenuOption(ModList.modMetadatas.get(modId).title, modId, optionLoopNum);
				page.add(modOption);
				optionLoopNum++;

				coolId = modId;
			}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
		{
			curSelected -= 1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.DOWN_P)
		{
			curSelected += 1;
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (controls.BACK)
		{
			PolymodHandler.loadMods();
			FlxG.switchState(new MainMenuState());
		}

		if (curSelected < 0)
			curSelected = page.length - 1;

		if (curSelected >= page.length)
			curSelected = 0;

		var bruh = 0;

		for (x in page.members)
		{
			x.Alphabet_Text.targetY = bruh - curSelected;
			bruh++;
		}
	}
}
#end