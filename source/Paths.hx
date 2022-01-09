package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import modloader.PolymodHandler;
import modloader.ModsMenu;
import modloader.ModList;
import modloader.ModsMenuOption;
import flash.media.Sound;

using StringTools;

class Paths
{
	inline public static var VIDEO_EXT = "mp4";
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	static public var modDir:String = null;
	public static var customSoundsLoaded:Map<String, Sound> = new Map();
	public static var customImagesLoaded:Map<String, Bool> = new Map<String, Bool>();

	public static var ignoredFolders:Array<String> = [
		'custom_characters',
		'data',
		'songs',
		'music',
		'sounds',
		'videos',
		'images',
		'weeks'
	];

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	inline static public function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace(' ', '-');
	}

	static function getModPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibrarymodPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibrarymodPathForce(file, "images");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getmodPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline public static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static function getLibrarymodPathForce(file:String, library:String)
	{
		return '$library:mods/$library/$file';
	}

	inline static function getmodPreloadPath(file:String)
	{
		return 'mods/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('$key.txt', TEXT, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('$key.lua', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	inline static public function cooljson(key:String, ?library:String)
	{
		return getPath('$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	static public function video(key:String)
	{
		#if MODS
		var file:String = modVideo(key);
		if (FileSystem.exists(file))
		{
			return file;
		}
		else
			return 'assets/videos/$key.$VIDEO_EXT';
		#else
		return 'assets/videos/$key.$VIDEO_EXT';
		#end
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String):Any
	{
		#if MODS
		var file:Sound = returnSongFile(modsSongs(song.toLowerCase().replace(' ', '-') + '/Voices'));
		if (file != null)
		{
			return file;
		}
		#end

		return 'songs:assets/songs/${song.toLowerCase().replace(' ', '-')}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String):Any
	{
		#if MODS
		var file:Sound = returnSongFile(modsSongs(song.toLowerCase().replace(' ', '-') + '/Inst'));
		if (file != null)
		{
			return file;
		}
		#end

		return 'songs:assets/songs/${song.toLowerCase().replace(' ', '-')}/Inst.$SOUND_EXT';
	}

	inline static private function returnSongFile(file:String):Sound
	{
		#if MODS
		if (FileSystem.exists(file))
		{
			if (!customSoundsLoaded.exists(file))
			{
				customSoundsLoaded.set(file, Sound.fromFile(file));
			}
			return customSoundsLoaded.get(file);
		}
		#end
		return null;
	}

	static public function addCustomGraphic(key:String):FlxGraphic
	{
		#if MODS
		if (FileSystem.exists(modsImages(key)))
		{
			if (!customImagesLoaded.exists(key))
			{
				var newBitmap:BitmapData = BitmapData.fromFile(modsImages(key));
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, key);
				newGraphic.persist = true;
				FlxG.bitmap.addGraphic(newGraphic);
				customImagesLoaded.set(key, true);
			}
			return FlxG.bitmap.get(key);
		}
		#end
		return null;
	}

	inline static public function image(key:String, ?library:String):Dynamic
	{
		#if MODS
		var imageToReturn:FlxGraphic = addCustomGraphic(key);
		if (imageToReturn != null)
			return imageToReturn;
		#end

		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function modTxt(key:String)
	{
		return modFolder('$key.txt');
	}

	inline static public function mods(key:String = '')
	{
		return 'mods/' + key;
	}

	inline static public function modsSongs(key:String)
	{
		return modFolder('songs/' + key + '.' + SOUND_EXT);
	}

	inline static public function modSong(key:String)
	{
		return modFolder(key + '.json');
	}

	inline static public function modsJson(key:String)
	{
		return modFolder('data/' + key + '.json');
	}

	inline static public function modImage(key:String)
	{
		return modFolder('stages/' + key + '.png');
	}

	inline static public function modIcon(key:String)
	{
		return modFolder('images/' + key + '.png');
	}

	inline static public function modsXml(key:String)
	{
		return modFolder('images/' + key + '.xml');
	}

	inline static public function modVideo(key:String)
	{
		return modFolder('videos/' + key + '.' + VIDEO_EXT);
	}

	inline static public function modsImages(key:String)
	{
		return modFolder('images/' + key + '.png');
	}

	inline static public function modsPng(key:String)
	{
		return modFolder(key + '.png');
	}

	inline static public function modLua(key:String)
	{
		return modFolder('$key.lua');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getModsSparrowAtlas(key:String, ?library:String)
	{
		#if MODS
		var imageLoaded:FlxGraphic = addCustomGraphic(key);
		var xmlExists:Bool = false;
		if (FileSystem.exists(modsXml(key)))
		{
			xmlExists = true;
		}

		return FlxAtlasFrames.fromSparrow((imageLoaded != null ? imageLoaded : image(key, library)),
			(xmlExists ? File.getContent(modsXml(key)) : file('images/$key.xml', library)));
		#end
	}

	// why, spirit?
	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	static public function modFolder(key:String)
	{
		#if MODS
		if (modDir != null && modDir.length > 0)
		{
			// psych engine for the win
			var fileToCheck:String = mods(modDir + '/' + key);
			if (FileSystem.exists(fileToCheck))
			{
				return fileToCheck;
			}
		}
		if (FileSystem.exists('mods/' + PolymodHandler.swagMeta + '/' + key)
			&& ModsMenuOption.enabledMods.contains(PolymodHandler.swagMeta))
		{
			return 'mods/' + PolymodHandler.swagMeta + '/' + key;
		}

		return 'mods/' + key;
		#else
		return key;
		#end
	}
}
