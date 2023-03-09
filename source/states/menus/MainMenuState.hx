package states.menus;

#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.math.FlxMath;
import states.menus.modloader.ModsMenu;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	// YOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
	public var optionShit:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/menuButtonList'));
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;

	override function create()
	{
		MemoryManager.freeTrashedAssets();
		MemoryManager.freeAllAssets();

		if (FlxG.save.data.mousescroll)
		{
			FlxG.mouse.visible = true;
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		LoggingUtil.writeToLogFile('Menu Buttons Are: ' + optionShit.join('\n') + ', ');

		optionShit = CoolUtil.coolTextFile(Paths.txt('data/menuButtonList'));

		#if MODS
		if (FileSystem.exists(Paths.modTxt('data/menuButtonList')) && FileSystem.exists(Paths.txt('data/menuButtonList')))
		{
			optionShit = File.getContent(Paths.modTxt('data/menuButtonList')).trim().split('\n');

			for (i in 0...optionShit.length)
			{
				optionShit[i] = optionShit[i].trim();
			}
		}
		else
		{
			optionShit = CoolUtil.coolTextFile(Paths.txt('data/menuButtonList'));
		}
		#else
		optionShit = CoolUtil.coolTextFile(Paths.txt('data/menuButtonList'));
		#end

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		var scrollEffect:Float = Math.max(0.10 - (0.03 * (optionShit.length - 4)), 0.1);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, scrollEffect);
		bg.setGraphicSize(Std.int(bg.width * 1.14));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, scrollEffect);
		magenta.setGraphicSize(Std.int(magenta.width * 1.14));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			#if MODS
			if (FileSystem.exists(Paths.modIcon('menubuttons/' + optionShit[i])))
			{
				menuItem.frames = Paths.getModsSparrowAtlas('menubuttons/' + optionShit[i]);
			}
			else
			{
				menuItem.frames = Paths.getSparrowAtlas('menubuttons/' + optionShit[i]);
			}
			#else
			menuItem.frames = Paths.getSparrowAtlas('menubuttons/' + optionShit[i]);
			#end
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.y = 0.95;
			menuItem.scale.x = 0.95;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < optionShit.length - 1)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = true;
			menuItem.updateHitbox();
		}

		if (optionShit.length > 9)
		{
			bg.setGraphicSize(Std.int((magenta.width * 1.15 + optionShit.length - 9) - 1));
		}

		if (optionShit.length > 9)
		{
			magenta.setGraphicSize(Std.int((magenta.width * 1.15 + optionShit.length - 9) - 1));
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 22, 0, "Friday Night Funkin' v0.2.8 - Mag Engine v" + Application.current.meta.get('version'),
			12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = true;
		add(versionShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 5.6, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				if (FlxG.save.data.mousescroll)
				{
					FlxG.mouse.visible = false;
				}
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.mouse.wheel != 0 && FlxG.save.data.mousescroll)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeItem(-FlxG.mouse.wheel);
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && FlxG.save.data.mousescroll))
			{
				if (optionShit[curSelected] == 'donate')
					CoolUtil.openURL('https://ninja-muffin24.itch.io/funkin');
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										MusicBeatState.switchState(new StoryMenuState());
										LoggingUtil.writeToLogFile('Selected Story Mode!');
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
										LoggingUtil.writeToLogFile('Selected Freeplay!');
									case 'credits':
										MusicBeatState.switchState(new CreditsMenu());
										LoggingUtil.writeToLogFile('Selected Credits!');
									#if desktop
									case 'editors':
										MusicBeatState.switchState(new states.tools.EditorMenuState());
										LoggingUtil.writeToLogFile('Selected Editors!');
									#end
									#if MODS
									case 'mods':
										MusicBeatState.switchState(new ModsMenu());
										LoggingUtil.writeToLogFile('Selected Mods!');
									#end
									case 'social':
										MusicBeatState.switchState(new SocialsState());
										LoggingUtil.writeToLogFile('Selected Social!');
									case 'options':
										MusicBeatState.switchState(new OptionsMenu());
										LoggingUtil.writeToLogFile('Selected Options!');
									#if SKINS
									case 'skins':
										MusicBeatState.switchState(new states.menus.skinloader.SkinsMenu());
										LoggingUtil.writeToLogFile('Selected Skins!');
									#end
										#if MODS
										default:
											MusicBeatState.switchState(new modding.CustomState(optionShit[curSelected], true));
											LoggingUtil.writeToLogFile('Selected A Custom State!');
										#end
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
