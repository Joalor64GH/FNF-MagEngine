package scripting;

#if (MODS && SCRIPTS)
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import flixel.input.keyboard.FlxKey;
import lime.app.Application;

using StringTools;

enum HScriptType
{
	SCRIPT_SONG;
	SCRIPT_NOTETYPE;
	SCRIPT_EVENT;
	SCRIPT_STATE;
	SCRIPT_SUBSTATE;
	SCRIPT_CUTSCENE;
}

class HScriptHandler
{
	public var parser:Parser;
	public var interp:Interp;
	public var ast:Any;

	public function new(script:String, type:HScriptType, name:String)
	{
		var interp = new Interp();
		this.interp = interp;

		this.parser = new Parser();
		parser.allowTypes = true;
		parser.allowJSON = true;
		parser.allowMetadata = true;

		initFields(type);

		#if HSCRIPT_ERRORS
		try
		{
			this.ast = parser.parseString(script);
		}
		catch (e:Error)
		{
			var messageToSend = '${name.split(".")[0]}:${e.line} characters: ${e.pmin}-${e.pmax} ';
			switch (e.e)
			{
				case EInvalidChar(c):
					messageToSend += "Invalid character: " + c;
				case EUnexpected(s):
					messageToSend += "Unexpected " + s;
				case EUnterminatedString:
					messageToSend += "Unterminated string";
				case EUnterminatedComment:
					messageToSend += "Unterminated comment";
				case EInvalidPreprocessor(msg):
					messageToSend += "Invalid preprocessor: " + msg;
				case EUnknownVariable(v):
					messageToSend += "Unknown variable: " + v;
				case EInvalidIterator(v):
					messageToSend += "Invalid iterator: " + v;
				case EInvalidOp(op):
					messageToSend += "Invalid operator: " + op;
				case EInvalidAccess(f):
					messageToSend += "Invalid access: " + f;
				default:
					trace(e.e);
			}
			trace(messageToSend);
			Application.current.window.alert(messageToSend, "Error on HScript Script!");
		}
		#else
		this.ast = parser.parseString(script);
		#end
	}

	private function initFields(type:HScriptType)
	{
		interp.variables.set("create", function()
		{
		});
		interp.variables.set("createPost", function()
		{
		});
		interp.variables.set("update", function(elapsed:Float)
		{
		});
		interp.variables.set("updatePost", function(elapsed:Float)
		{
		});
		interp.variables.set("import", function(classToResolve:String)
		{
			interp.variables.set(classToResolve.replace(" ", ""), Type.resolveClass(classToResolve.replace(" ", "")));
			var trimmedClass = "";
			if (classToResolve.contains("."))
			{
				for (i in 0...classToResolve.split(".").length)
				{
					if (i != classToResolve.split(".").length - 1)
					{
						trimmedClass = classToResolve.replace(classToResolve.split(".")[i], "");
					}
					else
					{
						var alphabet = "abcdefghijklmnopqrstuvwusyz";
						for (alphachar in alphabet.split(""))
						{
							if (trimmedClass.contains("." + alphachar.toUpperCase()))
							{
								trimmedClass = trimmedClass.replace(trimmedClass.split("." + alphachar.toUpperCase())[0], "");
							}
						}
						interp.variables.set(trimmedClass.replace(" ", "").replace(".", ""), Type.resolveClass(classToResolve.replace(" ", "")));
					}
				}
			}
		});

		if (type == HScriptType.SCRIPT_NOTETYPE)
			return;

		interp.variables.set("stepHit", function()
		{
		});
		interp.variables.set("stepHitPost", function()
		{
		});
		interp.variables.set("beatHit", function()
		{
		});
		interp.variables.set("beatHitPost", function()
		{
		});
		if (type == HScriptType.SCRIPT_SONG)
			interp.variables.set("game", PlayState.play);
		if (type == HScriptType.SCRIPT_STATE || type == HScriptType.SCRIPT_SUBSTATE)
			return;
		interp.variables.set("endSong", function(isStoryMode:Bool)
		{
		});
		interp.variables.set("dialogue", function()
		{
		});
		interp.variables.set("dialogueEnd", function()
		{
		});
		interp.variables.set("cutscene", function()
		{
		});
		interp.variables.set("countdown", function()
		{
		});
		interp.variables.set("countdownStarted", function()
		{
		});
		interp.variables.set("countdownTick", function(tick:Int)
		{
		});
		interp.variables.set("scoreUpdate", function(miss:Bool)
		{
		});
		interp.variables.set("dialogueChange", function(count:Int)
		{
		});
		interp.variables.set("startSong", function()
		{
		});
		interp.variables.set("event", function()
		{
		});
		interp.variables.set("resume", function()
		{
		});
		interp.variables.set("pause", function()
		{
		});
		interp.variables.set("noteSpawn", function(note:Note)
		{
		});
		interp.variables.set("noteDestroy", function(note:Note)
		{
		});
		interp.variables.set("gameOver", function()
		{
		});
		interp.variables.set("cameraFocus", function(isDad:Bool)
		{
		});
		interp.variables.set("cameraFocused", function()
		{
		});
		interp.variables.set("noteMissPress", function(dir:Int = 1)
		{
		});
		interp.variables.set("noteMiss", function(note:Note)
		{
		});
		interp.variables.set("goodNoteHit", function(note:Note)
		{
		});
		interp.variables.set("boyfriendNoteHit", function()
		{
		});
		interp.variables.set("opponentNoteHit", function()
		{
		});
	}

	public function interpExecute()
	{
		try
		{
			interp.execute(ast);
		}
		catch (e)
		{
			return -1;
		}
		return interp.execute(ast);
	}

	public function getInterp()
	{
		return interp;
	}
}
#end
