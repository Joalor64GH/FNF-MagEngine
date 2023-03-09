package states;

#if desktop
import backend.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.math.FlxMath;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class SocialsState extends MusicBeatState
{
	static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['youtube', 'twitter'];

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

		LoggingUtil.writeToLogFile('In The Socials Menu!');

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
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
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 22, 0, "FNF v0.2.7.1 - Mag Engine v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = true;
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

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
				MusicBeatState.switchState(new MainMenuState());
			}

			if (FlxG.mouse.wheel != 0 && FlxG.save.data.mousescroll)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				changeItem(-FlxG.mouse.wheel);
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && FlxG.save.data.mousescroll))
			{
				switch (optionShit[curSelected])
				{
					case 'youtube':
						#if MODS
						if (FileSystem.exists(Paths.modTxt('data/youtube')) && FileSystem.exists(Paths.txt('data/youtube')))
						{
							CoolUtil.openURL(File.getContent(Paths.modTxt('data/youtube')));
						}
						else
						{
							CoolUtil.openURL(OpenFlAssets.getText(Paths.txt('data/youtube')));
						}
						#else
						CoolUtil.openURL(OpenFlAssets.getText(Paths.txt('data/youtube')));
						#end
					case 'twitter':
						#if MODS
						if (FileSystem.exists(Paths.modTxt('data/twitter')) && FileSystem.exists(Paths.txt('data/twitter')))
						{
							CoolUtil.openURL(File.getContent(Paths.modTxt('data/twitter')));
						}
						else
						{
							CoolUtil.openURL(OpenFlAssets.getText(Paths.txt('data/twitter')));
						}
						#else
						CoolUtil.openURL(OpenFlAssets.getText(Paths.txt('data/twitter')));
						#end
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
