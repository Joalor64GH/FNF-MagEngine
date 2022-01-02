package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;

	public var char:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon()
	{
		if (isOldIcon = !isOldIcon)
			changeIcon('bf-old');
		else
			changeIcon('bf');
	}

	public function changeIcon(newChar:String)
	{
		if (char != newChar)
		{
			var iconsList = CoolUtil.coolTextFile(Paths.txt('data/iconsList'));

			for (i in 0...iconsList.length)
			{
				var data:Array<String> = iconsList[i].split(':');
				if (data[1] != null && newChar == data[0])
				{
					newChar = data[1];
					break;
				}
			}

			var name:String = 'icons/icon-' + newChar;
			if (!Paths.fileExists('images/' + name + '.png', IMAGE))
				name = 'icons/icon-face';

			loadGraphic(Paths.image(name), true, 150, 150);
			animation.add(newChar, [0, 1], 0, false, isPlayer);
			animation.play(newChar);
			char = newChar;

			antialiasing = !newChar.endsWith('-pixel');
		}
	}

	public function getCharacter():String
	{
		return char;
	}
}
