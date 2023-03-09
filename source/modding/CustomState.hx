package modding;

#if desktop
import backend.Discord.DiscordClient;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
#end
#if (MODS && SCRIPTS)
import scripting.HScriptHandler.HScriptType;
import scripting.HScriptHandler;
#end
import states.menus.modloader.ModsMenu;
import hscript.Interp;
import flixel.FlxG;

using StringTools;

#if (MODS && SCRIPTS)
class CustomState extends MusicBeatState
{
	public var name:String;

	var isMenuState:Bool;
	var menuState:MainMenuState;

	public static var filesInserted:Array<String> = [];
	public static var interp:Interp;

	public function new(name:String = "", isMenuState:Bool = false)
	{
		super();

		this.name = name;
		this.isMenuState = isMenuState;
	}

	override public function create()
	{
		MemoryManager.freeTrashedAssets();
		MemoryManager.freeAllAssets();

		filesInserted = [];

		var folders:Array<String> = [Paths.getPreloadPath('custom_states/')];
		folders.insert(0, Paths.modFolder('custom_states/'));
		for (folder in folders)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if ((file.endsWith('.hx') || file.endsWith('.hscript')) && !filesInserted.contains(file))
					{
						var expr = File.getContent(Paths.state(file));
						var hscriptInst = new HScriptHandler(expr, HScriptType.SCRIPT_STATE, file);

						hscriptInst.getInterp().variables.set("state", this);

						name = file;
						hscriptInst.interpExecute();

						interp = hscriptInst.getInterp();

						filesInserted.push(file);
					}
				}
			}
		}

		callOnHScript("create");

		super.create();
	}

	override public function update(elapsed:Float)
	{
		callOnHScript("update", [elapsed]);

		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.resetState();
			MusicBeatState.switchState(new MainMenuState());
		}
	}

	override function stepHit()
	{
		callOnHScript("stepHit");

		super.stepHit();

		callOnHScript("stepHitPost");
	}

	override function beatHit()
	{
		callOnHScript("beatHit");

		super.beatHit();

		callOnHScript("beatPost");
	}

	public function callOnHScript(functionToCall:String, ?params:Array<Any>):Dynamic
	{
		if (interp == null)
		{
			return null;
		}
		if (interp.variables.exists(functionToCall))
		{
			var functionH = interp.variables.get(functionToCall);
			if (params == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, params);
				return result;
			}
		}
		return null;
	}

	public function openCustomState(stateName:String)
	{
		MusicBeatState.switchState(new modding.CustomState(stateName, false));
	}

	public function openCustomSubState(stateName:String)
	{
		openSubState(new modding.CustomSubState(stateName, false));
	}
}
#end
