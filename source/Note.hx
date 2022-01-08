package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;
#if MODS
import polymod.format.ParseRules.TargetSignatureElement;
#end

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var noteType:Int = 0;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var isDangerousNote:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	var gfxLetter:Array<String> = [
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
		'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R'
	];

	public static var scales:Array<Float> = [0.9, 0.85, 0.8, 0.7, 0.66, 0.6, 0.55, 0.50, 0.46, 0.39, 0.3];
	public static var lessX:Array<Int> = [0, 0, 0, 0, 0, 8, 7, 8, 8, 7, 6];
	public static var separator:Array<Int> = [0, 0, 1, 1, 2, 2, 2, 3, 3, 4, 4];
	public static var xtra:Array<Int> = [150, 89, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	public static var posRest:Array<Int> = [0, 0, 0, 0, 25, 32, 46, 52, 60, 40, 30];
	public static var gridSizes:Array<Int> = [40, 40, 40, 40, 40, 40, 40, 40, 40, 35, 30];
	public static var offsets:Array<Dynamic> = [
		[20, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 10], [10, 20], [10, 10], [10, 10]];

	public static var minMania:Int = 0;
	public static var maxMania:Int = 10;
	public static var defaultMania:Int = 3;

	public static var keysShit:Map<Int, Map<String, Dynamic>> = [
		0 => [
			"letters" => ["E"],
			"anims" => ["UP"],
			"strumAnims" => ["SPACE"],
			"pixelAnimIndex" => [4]
		],
		1 => [
			"letters" => ["A", "D"],
			"anims" => ["LEFT", "RIGHT"],
			"strumAnims" => ["LEFT", "RIGHT"],
			"pixelAnimIndex" => [0, 3]
		],
		2 => [
			"letters" => ["A", "E", "D"],
			"anims" => ["LEFT", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "SPACE", "RIGHT"],
			"pixelAnimIndex" => [0, 4, 3]
		],
		3 => [
			"letters" => ["A", "B", "C", "D"],
			"anims" => ["LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT"],
			"pixelAnimIndex" => [0, 1, 2, 3]
		],
		4 => [
			                  "letters" => ["A", "B", "E", "C", "D"], "anims" => ["LEFT", "DOWN", "UP", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "SPACE", "UP", "RIGHT"],              "pixelAnimIndex" => [0, 1, 4, 2, 3]
		],
		5 => [
			                     "letters" => ["A", "C", "D", "F", "B", "I"], "anims" => ["LEFT", "UP", "RIGHT", "LEFT", "DOWN", "RIGHT"],
			"strumAnims" => ["LEFT", "UP", "RIGHT", "LEFT", "DOWN", "RIGHT"],                      "pixelAnimIndex" => [0, 2, 3, 5, 1, 8]
		],
		6 => [
			                         "letters" => ["A", "C", "D", "E", "F", "B", "I"], "anims" => ["LEFT", "UP", "RIGHT", "UP", "LEFT", "DOWN", "RIGHT"],
			"strumAnims" => ["LEFT", "UP", "RIGHT", "SPACE", "LEFT", "DOWN", "RIGHT"],                         "pixelAnimIndex" => [0, 2, 3, 4, 5, 1, 8]
		],
		7 => [
			                         "letters" => ["A", "B", "C", "D", "F", "G", "H", "I"], "anims" =>
			["LEFT", "UP", "DOWN", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"],                              "pixelAnimIndex" =>
			[0, 1, 2, 3, 5, 6, 7, 8]
		],
		8 => [
			                             "letters" => ["A", "B", "C", "D", "E", "F", "G", "H", "I"], "anims" =>
			["LEFT", "DOWN", "UP", "RIGHT", "UP", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "SPACE", "LEFT", "DOWN", "UP", "RIGHT"],                                 "pixelAnimIndex" =>
			[0, 1, 2, 3, 4, 5, 6, 7, 8]
		],
		9 => [
			"letters" => ["A", "B", "C", "D", "E", "N", "F", "G", "H", "I"],
			"anims" => ["LEFT", "DOWN", "UP", "RIGHT", "UP", "UP", "LEFT", "DOWN", "UP", "RIGHT"],
			"strumAnims" => ["LEFT", "DOWN", "UP", "RIGHT", "SPACE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"],
			"pixelAnimIndex" => [0, 1, 2, 3, 4, 13, 5, 6, 7, 8]
		],
		10 => [
			"letters" => ["A", "B", "C", "D", "J", "N", "M", "F", "G", "H", "I"],
			"anims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "LEFT", "UP", "RIGHT", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"strumAnims" => [
				"LEFT", "DOWN", "UP", "RIGHT", "CIRCLE", "CIRCLE", "CIRCLE", "LEFT", "DOWN", "UP", "RIGHT"
			],
			"pixelAnimIndex" => [0, 1, 2, 3, 9, 13, 12, 5, 6, 7, 8]
		]
	];

	public static var ammo:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];

	public static var pixelScales:Array<Float> = [1.2, 1.15, 1.1, 1, 0.9, 0.83, 0.8, 0.74, 0.7, 0.6, 0.55];

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public function new(strumTime:Float, noteData:Int, ?pixelNote:Bool = false, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += PlayState.STRUM_X + 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		if (isSustainNote && prevNote.noteType == 1)
			noteType == 1;
		else if (isSustainNote && prevNote.noteType == 2)
			noteType == 2;

		this.noteData = noteData;

		this.noteType = noteType;

		this.isDangerousNote = (this.noteType == 1 || this.noteType == 2);

		if (pixelNote)
		{
			loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

			animation.add('greenScroll', [6]);
			animation.add('redScroll', [7]);
			animation.add('blueScroll', [5]);
			animation.add('purpleScroll', [4]);

			if (isSustainNote)
			{
				loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

				animation.add('purpleholdend', [4]);
				animation.add('greenholdend', [6]);
				animation.add('redholdend', [7]);
				animation.add('blueholdend', [5]);

				animation.add('purplehold', [0]);
				animation.add('greenhold', [2]);
				animation.add('redhold', [3]);
				animation.add('bluehold', [1]);
			}

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		}
		else
		{
			antialiasing = true;
			switch (noteType)
			{
				case 1:
					{
						frames = Paths.getSparrowAtlas('HURT_NOTE_assets');

						animation.addByPrefix('greenScroll', 'green0');
						animation.addByPrefix('redScroll', 'red0');
						animation.addByPrefix('blueScroll', 'blue0');
						animation.addByPrefix('purpleScroll', 'purple0');

						setGraphicSize(Std.int(width * 0.7));
					}
				case 2:
					{
						frames = Paths.getSparrowAtlas('KILL_NOTE_assets');

						animation.addByPrefix('greenScroll', 'green0');
						animation.addByPrefix('redScroll', 'red0');
						animation.addByPrefix('blueScroll', 'blue0');
						animation.addByPrefix('purpleScroll', 'purple0');

						setGraphicSize(Std.int(width * 0.7));
					}
				default:
					{
						frames = Paths.getSparrowAtlas('NOTE_assets');

						animation.addByPrefix('greenScroll', 'green0');
						animation.addByPrefix('redScroll', 'red0');
						animation.addByPrefix('blueScroll', 'blue0');
						animation.addByPrefix('purpleScroll', 'purple0');

						animation.addByPrefix('purpleholdend', 'pruple end hold');
						animation.addByPrefix('greenholdend', 'green hold end');
						animation.addByPrefix('redholdend', 'red hold end');
						animation.addByPrefix('blueholdend', 'blue hold end');

						animation.addByPrefix('purplehold', 'purple hold piece');
						animation.addByPrefix('greenhold', 'green hold piece');
						animation.addByPrefix('redhold', 'red hold piece');
						animation.addByPrefix('bluehold', 'blue hold piece');

						setGraphicSize(Std.int(width * 0.7));
					}
			}
		}
		updateHitbox();

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			alpha = 0.6;
			if (FlxG.save.data.downscroll)
				flipY = true;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isSustainNote && prevNote.noteType == 1)
		{
			this.kill();
		}

		if (isSustainNote && prevNote.noteType == 2)
		{
			this.kill();
		}

		if (mustPress)
		{
			if (noteType != 1 && noteType != 2)
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 0.6)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.4))
					canBeHit = true;
				else
					canBeHit = false;
			}
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
