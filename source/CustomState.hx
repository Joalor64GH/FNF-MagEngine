package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import Song.MidSongEvent;
import flixel.FlxCamera;
import shaders.ChromaticAberration;
import flixel.FlxG;
import tools.StageEditor;
import tools.StageEditor.LayerFile;
import tools.StageEditor.StageFile;
import tools.StageEditor.StageData;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import haxe.Exception;
import openfl.Lib;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
#end
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import modloader.ModsMenu;

using StringTools;

class CustomState extends FlxState
{
	var name:String;
	var isMenuState:Bool;
	var menuState:MainMenuState;

	public function new(?name:String = "", ?isMenuState:Bool = false)
	{
		super();

		this.name = name;
		this.isMenuState = isMenuState;

		var menuBG = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;

		var infoText = new FlxText(0, 0, 0, "Hello, World!", 12);
		infoText.scrollFactor.set();
		infoText.setFormat("VCR OSD Mono", 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.borderSize = 2;
		infoText.screenCenter();
		infoText.visible = false;
		infoText.antialiasing = true;

		if (isMenuState)
		{
			menuState.optionShit.push(name);
		}

		#if (MODS && SCRIPTS)
		var filesInserted:Array<String> = [];
		var folders:Array<String> = [Paths.getPreloadPath('custom_states/')];
		folders.insert(0, Paths.modFolder('custom_states/'));
		for (folder in folders)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.hx') && !filesInserted.contains(file))
					{
						var expr = File.getContent(Paths.hscript(file));
						var parser = new hscript.Parser();
						parser.allowTypes;
						parser.allowJSON;
						parser.allowMetadata;
						var ast = parser.parseString(expr);
						var interp = new hscript.Interp();
						interp.variables.set("add", add);
						interp.variables.set("update", update);
						interp.variables.set("create", create);
						interp.variables.set("name", name);
						interp.variables.set("CustomState", CustomState);
						interp.variables.set("remove", remove);
						interp.variables.set("PlayState", PlayState);
						interp.variables.set("DiscordClient", DiscordClient);
						interp.variables.set("WiggleEffectType", WiggleEffect.WiggleEffectType);
						interp.variables.set("FlxBasic", flixel.FlxBasic);
						interp.variables.set("MidSongEvent", Song.MidSongEvent);
						interp.variables.set("FlxCamera", flixel.FlxCamera);
						interp.variables.set("ChromaticAberration", shaders.ChromaticAberration);
						interp.variables.set("FlxG", flixel.FlxG);
						interp.variables.set("FlxGame", flixel.FlxGame);
						interp.variables.set("FlxObject", flixel.FlxObject);
						interp.variables.set("FlxSprite", flixel.FlxSprite);
						interp.variables.set("FlxState", flixel.FlxState);
						interp.variables.set("FlxSubState", flixel.FlxSubState);
						interp.variables.set("FlxGridOverlay", flixel.addons.display.FlxGridOverlay);
						interp.variables.set("FlxTrail", flixel.addons.effects.FlxTrail);
						interp.variables.set("FlxTrailArea", flixel.addons.effects.FlxTrailArea);
						interp.variables.set("FlxEffectSprite", flixel.addons.effects.chainable.FlxEffectSprite);
						interp.variables.set("FlxWaveEffect", flixel.addons.effects.chainable.FlxWaveEffect);
						interp.variables.set("FlxTransitionableState", flixel.addons.transition.FlxTransitionableState);
						interp.variables.set("FlxAtlas", flixel.graphics.atlas.FlxAtlas);
						interp.variables.set("FlxAtlasFrames", flixel.graphics.frames.FlxAtlasFrames);
						interp.variables.set("FlxTypedGroup", flixel.group.FlxGroup.FlxTypedGroup);
						interp.variables.set("FlxMath", flixel.math.FlxMath);
						interp.variables.set("FlxPoint", flixel.math.FlxPoint);
						interp.variables.set("FlxRect", flixel.math.FlxRect);
						interp.variables.set("FlxSound", flixel.system.FlxSound);
						interp.variables.set("FlxText", flixel.text.FlxText);
						interp.variables.set("FlxEase", flixel.tweens.FlxEase);
						interp.variables.set("FlxTween", flixel.tweens.FlxTween);
						interp.variables.set("FlxBar", flixel.ui.FlxBar);
						interp.variables.set("FlxCollision", flixel.util.FlxCollision);
						interp.variables.set("FlxSort", flixel.util.FlxSort);
						interp.variables.set("FlxStringUtil", flixel.util.FlxStringUtil);
						interp.variables.set("FlxTimer", flixel.util.FlxTimer);
						interp.variables.set("Json", Json);
						interp.variables.set("Assets", lime.utils.Assets);
						interp.variables.set("ShaderFilter", openfl.filters.ShaderFilter);
						interp.variables.set("Exception", haxe.Exception);
						interp.variables.set("Lib", openfl.Lib);
						interp.variables.set("OpenFlAssets", openfl.utils.Assets);
						#if sys
						interp.variables.set("File", sys.io.File);
						interp.variables.set("FileSystem", sys.FileSystem);
						interp.variables.set("FlxGraphic", flixel.graphics.FlxGraphic);
						interp.variables.set("BitmapData", openfl.display.BitmapData);
						#end
						interp.variables.set("Parser", hscript.Parser);
						interp.variables.set("Interp", hscript.Interp);
						interp.variables.set("ModsMenu", modloader.ModsMenu);
						interp.variables.set("Paths", Paths);
						interp.execute(ast);
						trace(interp.execute(ast));

						filesInserted.push(file);
					}

					if (file == null)
					{
						add(menuBG);
						add(infoText);
					}
				}
			}
		}
		#end
	}

	override public function create()
	{
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
