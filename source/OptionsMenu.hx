/// same code used in ke modified for use in me
package;

import lime.app.Application;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import openfl.display.FPS;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import lime.system.DisplayMode;

class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;

	static var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory("Preferences", [
			new DownscrollOption(''),
			new AccuracyOption(''),
			new GhostTappingOption(''),
			new FPSOption(''),
			new MEMOption(''),
			new VerOption('')
		]),
		new OptionCategory("Controls", [new DFJKOption(controls)]),
		new OptionCategory("Notes", [new SplooshOption('')])
	];

	private var grpCheckboxes:FlxTypedGroup<CheckboxThingie>;

	var fpsthing:FlxText;

	public var acceptInput:Bool = true;

	public var currentDescription:String = "";

	private var grpControls:FlxTypedGroup<Alphabet>;

	var currentSelectedCat:OptionCategory;

	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		grpCheckboxes = new FlxTypedGroup<CheckboxThingie>();
		add(grpCheckboxes);

		generateMainMenu();

		changeSelection();

		super.create();
	}

	function generateMainMenu()
	{
		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, FlxG.height / 5 + 70 * i + 25 * i, options[i].getName(), true);
			controlLabel.screenCenter(X);
			grpControls.add(controlLabel);
		}
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK)
			{
				if (isCat)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					isCat = false;
					grpControls.clear();
					grpCheckboxes.clear();
					generateMainMenu();
					curSelected = 0;
					changeSelection();
				}
				else
					MusicBeatState.switchState(new MainMenuState());
			}
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(-1);
			}
			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeSelection(1);
			}

			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.pressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.pressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
					else
					{
						if (FlxG.keys.justPressed.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (FlxG.keys.justPressed.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						if (FlxG.keys.justPressed.RIGHT)
							FlxG.save.data.offset += 0.1;
						else if (FlxG.keys.justPressed.LEFT)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
				}
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.justPressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.justPressed.LEFT)
						FlxG.save.data.offset -= 0.1;
				}
				else if (FlxG.keys.pressed.RIGHT)
					FlxG.save.data.offset += 0.1;
				else if (FlxG.keys.pressed.LEFT)
					FlxG.save.data.offset -= 0.1;
			}

			if (controls.RESET)
				FlxG.save.data.offset = 0;

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				if (isCat && currentSelectedCat.getOptions()[curSelected].press())
				{
					grpCheckboxes.members[curSelected].daValue = currentSelectedCat.getOptions()[curSelected].daValue;
					grpControls.members[curSelected].changeText(currentSelectedCat.getOptions()[curSelected].getDisplay());
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					grpCheckboxes.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
					{
						var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
						controlLabel.isMenuItem = true;
						controlLabel.targetY = i;
						grpControls.add(controlLabel);
						controlLabel.forceX = 150;

						if (currentSelectedCat.getOptions()[i].isBool)
						{
							var checkbox:CheckboxThingie = new CheckboxThingie(controlLabel.x - 105, controlLabel.y,
								currentSelectedCat.getOptions()[i].daValue);
							checkbox.sprTracker = controlLabel;
							checkbox.ID = i;
							grpCheckboxes.add(checkbox);
						}
					}
					curSelected = 0;
					changeSelection();
				}
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
