package;

import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import flixel.FlxSprite;
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;

import flash.media.Sound;

using StringTools;


class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	public static var modsthing:Map<String, Bool> = new Map<String, Bool>();
	static public var modDir:String = null;
	public static var customSoundsLoaded:Map<String, Sound> = new Map();
	public static var customImagesLoaded:Map<String, Bool> = new Map<String, Bool>();

	public static function destroyLoadedImages(ignoreCheck:Bool = false) {
		for (key in customImagesLoaded.keys()) {
			var graphic:FlxGraphic = FlxG.bitmap.get(key);
			if(graphic != null) {
				graphic.bitmap.dispose();
				graphic.destroy();
				FlxG.bitmap.removeByKey(key);
			}
		}
		Paths.customImagesLoaded.clear();
	}

	static var currentLevel:String;

	static public function getModFolders()
		{
			modsthing.set('data', true);
			modsthing.set('songs', true);
			modsthing.set('images', true);
			modsthing.set('videos', true);
			modsthing.set('sounds', true);
		}

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

	inline static public function formatToSongPath(path:String) {
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

	inline static function getPreloadPath(file:String)
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
	
		
		


	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}
	
	inline static public function video(key:String, ?library:String)
	{
		trace('assets/videos/$key.mp4');
		return getPath('videos/$key.mp4', BINARY, library);
	}
	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String):Any
		{
			var file:Sound = returnSongFile(modsSongs(song.toLowerCase().replace(' ', '-') + '/Voices'));
			if(file != null) {
				return file;
			}
	
			return 'songs:assets/songs/${song.toLowerCase().replace(' ', '-')}/Voices.$SOUND_EXT';
		}
	
		inline static public function inst(song:String):Any
		{
		
			var file:Sound = returnSongFile(modsSongs(song.toLowerCase().replace(' ', '-') + '/Inst'));
			if(file != null) {
				return file;
			}
		
			return 'songs:assets/songs/${song.toLowerCase().replace(' ', '-')}/Inst.$SOUND_EXT';
		}

	inline static private function returnSongFile(file:String):Sound
	{
		if(FileSystem.exists(file)) {
			if(!customSoundsLoaded.exists(file)) {
				customSoundsLoaded.set(file, Sound.fromFile(file));
			}
			return customSoundsLoaded.get(file);
		}
		return null;
	}

	inline static public function fileExists(key:String, type:AssetType, ?ignoreMods:Bool = false, ?library:String)
		{
			#if mods
			if(FileSystem.exists(mods(currentModDirectory + '/' + key)) || FileSystem.exists(mods(key))) {
				return true;
			}
			#end
			
			if(OpenFlAssets.exists(Paths.getPath(key, type, library))) {
				return true;
			}
			return false;
		}
	

	static public function addCustomGraphic(key:String):FlxGraphic {
		if(FileSystem.exists(modsImages(key))) {
			if(!customImagesLoaded.exists(key)) {
				var newBitmap:BitmapData = BitmapData.fromFile(modsImages(key));
				var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(newBitmap, false, key);
				newGraphic.persist = true;
				FlxG.bitmap.addGraphic(newGraphic);
				customImagesLoaded.set(key, true);
			}
			return FlxG.bitmap.get(key);
		}
		return null;
	}

	inline static public function image(key:String, ?library:String):Dynamic
		{
			var imageToReturn:FlxGraphic = addCustomGraphic(key);
			if(imageToReturn != null) return imageToReturn;
			return getPath('images/$key.png', IMAGE, library);
		}

		inline static public function coolimage(key:String, ?library:String):Dynamic
			{
				return getModPath('images/$key.png', IMAGE, library);
			}


	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';

	}

	inline static public function bruhtxt(key:String)
		{
			return modfold('$key.txt');
		}

	inline static public function mods(key:String = '') {
		return 'mods/' + key;
	}
	

	inline static public function modsSongs(key:String) {
		return modfold('songs/' + key + '.' + SOUND_EXT);
	}

	inline static public function modsong(key:String) {
		return modfold(key + '.json');
	}
	
	inline static public function modsJson(key:String) {
		return modfold('data/' + key + '.json');
	}


	inline static public function modimage(key:String) {
		return modfold('stages/' + key + '.png');
	}

	inline static public function modicon(key:String) {
		return modfold('images' + key + '.png');
	}
	
	inline static public function lua(key:String, ?library:String)
		{
			return getPath('data/$key.lua', TEXT, library);
		}

		inline static public function luaImage(key:String, ?library:String)
			{
				return getPath('data/$key.png', IMAGE, library);
			}
		

	inline static public function swagmodicon(key:String) {
		return modfold('shared/images' + key + '.png');
	}

	inline static public function modsXml(key:String) {
		return modfold('images/' + key + '.xml');
	}

	inline static public function jsonSYS(key:String, ?library:String)
		{
			#if sys
			return pathStyleSYS(key + ".json", library, "data");
			#end
		}

	inline static public function modvideo(key:String)
	{
		return modfold('videos/$key.mp4');
	}
	
	inline static public function modsImages(key:String) {
		return modfold('images/' + key + '.png');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
		{
			return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
		}
		inline static public function getSparrowAtlasBruh(key:String, ?library:String)
			{
				return getSparrowAtlas(key, library);
			}
		
	
	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	
	static public function modfold(key:String) {
		if(modDir != null && modDir.length > 0) {
			// psych engine for the win
			var fileToCheck:String = mods(modDir + '/' + key);
			if(FileSystem.exists(fileToCheck)) {
				return fileToCheck;
			}
		}
		return 'mods/' + key;
	}
	inline static public function pathStyleSYS(key:String, ?library:String, ?dataType:String = "images")
		{
			if(library != null)
				library = library + "/";
			else
				library = "";
	
			return "assets/" + library + dataType + "/" + key;
		}
}
