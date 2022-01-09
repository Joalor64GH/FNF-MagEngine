package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;

class OffsetsState extends MusicBeatState
{
	var camHUD:FlxCamera;
	var camGame:FlxCamera;

	override function create()
	{
		FlxG.sound.playMusic(Paths.music('breakfast', 'shared'));

		// STOLEN FROM PLAYSTATE LMAO!!!!
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		FlxG.camera.scroll.set(120, 130);

		CustomFadeTransition.nextCamera = camHUD;

		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback', 'shared'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront', 'shared'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			MusicBeatState.switchState(new OptionsMenu());
		}

		super.update(elapsed);
	}
}
