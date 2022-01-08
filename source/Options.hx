package;

import lime.app.Application;
import lime.system.DisplayMode;
import flixel.util.FlxColor;
import Controls.KeyboardScheme;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.Lib;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;

class OptionCategory
{
	private var _options:Array<Option> = new Array<Option>();

	public final function getOptions():Array<Option>
	{
		return _options;
	}

	public final function addOption(opt:Option)
	{
		_options.push(opt);
	}

	public final function removeOption(opt:Option)
	{
		_options.remove(opt);
	}

	private var _name:String = "New Category";

	public final function getName()
	{
		return _name;
	}

	public function new(catName:String, options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}
}

class Option
{
	public function new()
	{
		display = updateDisplay();
	}

	private var description:String = "";
	private var display:String;
	private var acceptValues:Bool = false;

	public var isBool:Bool = true;
	public var daValue:Bool = false;

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	public final function getDescription():String
	{
		return description;
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		return true;
	}

	private function updateDisplay():String
	{
		return "";
	}

	public function left():Bool
	{
		return false;
	}

	public function right():Bool
	{
		return false;
	}
}

class DownscrollOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.downscroll;
	}

	public override function press():Bool
	{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		daValue = FlxG.save.data.downscroll;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Downscroll";
	}
}

class PhotoSensitivityOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.PhotoSensitivity;
	}

	public override function press():Bool
	{
		FlxG.save.data.PhotoSensitivity = !FlxG.save.data.PhotoSensitivity;
		daValue = FlxG.save.data.PhotoSensitivity;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "PhotoSensitivity Mode";
	}
}

class AccuracyOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.accuracy;
	}

	public override function press():Bool
	{
		FlxG.save.data.accuracy = !FlxG.save.data.accuracy;
		daValue = FlxG.save.data.accuracy;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Accuracy";
	}
}

class GhostTappingOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.ghostTapping;
	}

	public override function press():Bool
	{
		FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
		daValue = FlxG.save.data.ghostTapping;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping";
	}
}

class SplooshOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.splooshes;
	}

	public override function press():Bool
	{
		FlxG.save.data.splooshes = !FlxG.save.data.splooshes;
		daValue = FlxG.save.data.splooshes;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Note Splashes";
	}
}

class ModChartOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.modchart;
	}

	public override function press():Bool
	{
		FlxG.save.data.modchart = !FlxG.save.data.modchart;
		daValue = FlxG.save.data.modchart;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "ModCharts";
	}
}

class FPSOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.fps;
	}

	public override function press():Bool
	{
		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
		daValue = FlxG.save.data.fps;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter";
	}
}

class MEMOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.mem;
	}

	public override function press():Bool
	{
		FlxG.save.data.mem = !FlxG.save.data.mem;
		(cast(Lib.current.getChildAt(0), Main)).toggleMem(FlxG.save.data.mem);
		daValue = FlxG.save.data.mem;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Info";
	}
}

class VerOption extends Option
{
	public function new(desc:String)
	{
		super();
		description = desc;
		daValue = FlxG.save.data.v;
	}

	public override function press():Bool
	{
		FlxG.save.data.v = !FlxG.save.data.v;
		(cast(Lib.current.getChildAt(0), Main)).toggleVers(FlxG.save.data.v);
		daValue = FlxG.save.data.v;
		display = updateDisplay();
		return true;
	}

	private override function updateDisplay():String
	{
		return "Version Display";
	}
}
