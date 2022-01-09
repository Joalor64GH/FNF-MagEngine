package;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;
	public var sprTracker:FlxSprite;

	public function new(?char:String = "bf", ?isPlayer:Bool = false)
	{
		super();

		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;

		changeIcon(char);
		scrollFactor.set();
	}

	public function swapOldIcon()
	{
		if (isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon('bf');
	}

	public function changeIcon(char:String)
	{
		var iconsList = CoolUtil.coolTextFile(Paths.txt('data/iconsList'));

		for (i in 0...iconsList.length)
		{
			var data:Array<String> = iconsList[i].split(':');
			if (data[1] != null && char == data[0])
			{
				char = data[1];
				break;
			}
		}

		if (!OpenFlAssets.exists(Paths.image('icons/icon-' + char)))
			char = 'face';

		loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);

		if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit'))
			antialiasing = false
		else
			antialiasing = true;

		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
