package modloader;

#if MODS
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
import flixel.ui.FlxButton;
import lime.utils.Assets;

class ModsMenu extends MusicBeatState
{
	var curSelected:Int = 0;

	var page:FlxTypedGroup<ModsMenuOption> = new FlxTypedGroup<ModsMenuOption>();

	public static var instance:ModsMenu;

	public static var coolId:String;
	public static var disableButton:FlxButton;
	public static var enableButton:FlxButton;

	var infoText:FlxText;
	var infoTextcool:FlxText;

	override function create()
	{
		var menuBG:FlxSprite;

		menuBG = new FlxSprite().loadGraphic(Paths.image('menuDesat'));

		menuBG.color = FlxColor.GRAY;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		infoText = new FlxText(0, 0, 0, "NO MODS INSTALLED!", 12);
		infoText.scrollFactor.set();
		infoText.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.screenCenter();
		infoText.visible = false;
		infoText.antialiasing = true;
		add(infoText);

		infoTextcool = new FlxText(750, 340, 0, "", 12);
		infoTextcool.scrollFactor.set();
		infoTextcool.setFormat(Paths.font("funkin.otf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoTextcool.borderSize = 2;
		infoTextcool.screenCenter(Y);

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("modbg"));
		// bg.screenCenter(Y);
		
		var bgtwo:FlxSprite = new FlxSprite(720, 0).loadGraphic(Paths.image("modbg"));
		bgtwo.screenCenter(Y);
		if (page.members != null) {
		add(bgtwo);

		add(infoTextcool);
		}

		ModsMenu.enableButton = new FlxButton(bg.x + 1120, 309, "Enable Mod", function()
            {
                page.members[curSelected].Mod_Enabled = true;
                if (!page.members[curSelected].enabledMods.contains(page.members[curSelected].Option_Value)) {
					page.members[curSelected].enabledMods.push(page.members[curSelected].Option_Value);
                }
                ModList.setModEnabled(page.members[curSelected].Option_Value, page.members[curSelected].Mod_Enabled);
            });

			ModsMenu.disableButton = new FlxButton(bg.x + 1120, 380, "Disable Mod", function()
				{
					page.members[curSelected].Mod_Enabled = false;
					if (page.members[curSelected].enabledMods.contains(page.members[curSelected].Option_Value)) {
						page.members[curSelected].enabledMods.remove(page.members[curSelected].Option_Value);
					}
					ModList.setModEnabled(page.members[curSelected].Option_Value, page.members[curSelected].Mod_Enabled);
				});

				enableButton.setGraphicSize(150, 70);
				enableButton.updateHitbox();
				enableButton.color = FlxColor.GREEN;
				enableButton.label.setFormat(Paths.font("pixel.otf"), 12, FlxColor.WHITE);
				enableButton.label.fieldWidth = 135;
				setLabelOffset(enableButton, 5, 22);

				disableButton.setGraphicSize(150, 70);
				disableButton.updateHitbox();
				disableButton.color = FlxColor.RED;
				disableButton.label.setFormat(Paths.font("pixel.otf"), 12, FlxColor.WHITE);
				disableButton.label.fieldWidth = 135;
				setLabelOffset(disableButton, 5, 22);

				if (page.members != null) {
				add(disableButton);
				add(enableButton);
				}
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

		for (modId in PolymodHandler.metadataArrays)
		{
			var modOption = new ModsMenuOption(ModList.modMetadatas.get(modId).title, modId, optionLoopNum);
			page.add(modOption);
			optionLoopNum++;

			coolId = modId;
		}

		infoText.visible = (page.length == 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (ModList.modMetadatas != null && PolymodHandler.metadataArrays != null) {
		infoTextcool.text = ModList.modMetadatas.get(PolymodHandler.metadataArrays[curSelected]).description;
		infoTextcool.visible = true;
		infoTextcool.antialiasing = true;
	    }
		else {
			remove(infoTextcool);
		}
		if (page.length > 0)
		{
			if (controls.UP_P)
			{
				curSelected--;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}

			if (controls.DOWN_P)
			{
				curSelected++;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			}
		}

		if (controls.BACK)
		{
			PolymodHandler.loadMods();
			FlxG.mouse.visible = false;
			LoadingState.loadAndSwitchState(new MainMenuState());
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
	//haxeflixel bro why
	function setLabelOffset(button:FlxButton, x:Float, y:Float)
		{
			for (point in button.labelOffsets)
			{
				point.set(x, y);
			}
		}
}
#end