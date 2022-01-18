package;

import openfl.Lib;

class OptionCategory
{
	private var _options:Array<Option> = [];

	public function new(catName:String, ?options:Array<Option>)
	{
		_name = catName;
		_options = options;
	}

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
}

class Option
{
	private var display:String;
	private var acceptValues:Bool = false;

	public var isBool:Bool = true;
	public var daValue:Bool = false;
	public var pref:String = null;

	// YOU SHOULD SET THE PREF VARIABLE!!!!
	public function new(pref:String)
	{
		display = updateDisplay();
		daValue = Prefs.get(pref);
		this.pref = pref;
	}

	public final function getDisplay():String
	{
		return display;
	}

	public final function getAccept():Bool
	{
		return acceptValues;
	}

	// Returns whether the label is to be updated.
	public function press():Bool
	{
		if (isBool)
			Prefs.set(pref, !Prefs.get(pref));

		daValue = Prefs.get(pref);
		display = updateDisplay();
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
	public function new()
	{
		super('downscroll');
	}

	private override function updateDisplay():String
	{
		return "Downscroll";
	}
}

class MiddlescrollOption extends Option
{
	public function new()
	{
		super('middlescroll');
	}

	private override function updateDisplay():String
	{
		return "Middlescroll";
	}
}

class PhotoSensitivityOption extends Option
{
	public function new()
	{
		super('photoSensitivity');
	}

	private override function updateDisplay():String
	{
		return "Photo Sensitivity";
	}
}

class GhostTappingOption extends Option
{
	public function new()
	{
		super('ghostTapping');
	}

	private override function updateDisplay():String
	{
		return "Ghost Tapping";
	}
}

class AccuracyOption extends Option
{
	public function new()
	{
		super('accuracy');
	}

	private override function updateDisplay():String
	{
		return "Accuracy Display";
	}
}

class OpponentNotesGlowOption extends Option
{
	public function new()
	{
		super('cpuNotesGlow');
	}

	private override function updateDisplay():String
	{
		return "Opponent Notes Glow";
	}
}

class SplooshOption extends Option
{
	public function new()
	{
		super('splooshes');
	}

	private override function updateDisplay():String
	{
		return "Note Splashes";
	}
}

class ModChartOption extends Option
{
	public function new()
	{
		super('modchart');
	}

	private override function updateDisplay():String
	{
		return "ModCharts";
	}
}

class CacheOption extends Option
{
	public function new()
	{
		super('cache');
	}

	private override function updateDisplay():String
	{
		return "Cache At Start";
	}
}

class RatingOption extends Option
{
	public function new()
	{
		super('ratingCntr');
	}

	private override function updateDisplay():String
	{
		return "Rating Counter";
	}
}

class FPSCapOption extends Option
{
	public function new()
	{
		super('fpsCap');
	}

	private override function updateDisplay():String
	{
		return "FPS Cap";
	}
}

class FPSOption extends Option
{
	public function new()
	{
		super('fps');
	}

	public override function press():Bool
	{
		super.press();
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(daValue);
		return true;
	}

	private override function updateDisplay():String
	{
		return "FPS Counter";
	}
}

class MEMOption extends Option
{
	public function new()
	{
		super('mem');
	}

	public override function press():Bool
	{
		super.press();
		(cast(Lib.current.getChildAt(0), Main)).toggleMem(daValue);
		return true;
	}

	private override function updateDisplay():String
	{
		return "Memory Info";
	}
}

class VerOption extends Option
{
	public function new()
	{
		super('v');
	}

	public override function press():Bool
	{
		super.press();
		(cast(Lib.current.getChildAt(0), Main)).toggleVers(daValue);
		return true;
	}

	private override function updateDisplay():String
	{
		return "Version Display";
	}
}

class TransparentStrumsOption extends Option
{
	public function new()
	{
		super('transparentStrums');
	}

	private override function updateDisplay():String
	{
		return "Transparent Strums";
	}
}
