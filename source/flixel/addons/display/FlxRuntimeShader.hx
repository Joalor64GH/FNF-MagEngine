package flixel.addons.display;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;

/**
 * An wrapper for Flixel/OpenFL's shaders, which takes fragment and vertex source
 * in the constructor instead of using macros, so it can be provided data
 * at runtime (for example, when using mods).
 * 
 * HOW TO USE:
 * 1. Create an instance of this class, passing the text of the `.frag` and `.vert` files.
 *    Note that you can set either of these to null (making them both null would make the shader do nothing???).
 * 2. Use `flxSprite.shader = runtimeShader` to apply the shader to the sprite.
 * 3. Use `runtimeShader.setFloat()`, `setBool()` etc. to modify any uniforms.
 * 4. Use `setBitmapData()` to add additional textures as `sampler2D` uniforms
 * 
 * @author MasterEric
 * @see https://github.com/openfl/openfl/blob/develop/src/openfl/utils/_internal/ShaderMacro.hx
 * @see https://dixonary.co.uk/blog/shadertoy
 */
class FlxRuntimeShader extends FlxShader
{
	#if FLX_DRAW_QUADS
	// We need to add stuff from FlxGraphicsShader too!
	#else
	// Only stuff from openfl.display.GraphicsShader is needed
	#end
	// These variables got copied from openfl.display.GraphicsShader
	// and from flixel.graphics.tile.FlxGraphicsShader.
	static final PRAGMA_HEADER:String = "#pragma header";
	static final PRAGMA_BODY:String = "#pragma body";

	final glVersion:Int = 120;

	static final glFragmentHeaderRaw:String = "
		#pragma version
		#pragma precision
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;
	"

	#if FLX_DRAW_QUADS
	// Add on more stuff!
	+ "
		uniform bool hasTransform;
		uniform bool hasColorTransform;
		vec4 flixel_texture2D(sampler2D bitmap, vec2 coord)
		{
			vec4 color = texture2D(bitmap, coord);
			if (!hasTransform)
			{
				return color;
			}
			if (color.a == 0.0)
			{
				return vec4(0.0, 0.0, 0.0, 0.0);
			}
			if (!hasColorTransform)
			{
				return color * openfl_Alphav;
			}
			color = vec4(color.rgb / color.a, color.a);
			mat4 colorMultiplier = mat4(0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
			color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			if (color.a > 0.0)
			{
				return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			}
			return vec4(0.0, 0.0, 0.0, 0.0);
		}
	";
	#else
	// No additional data.
	;
	#end
	static final glVertexHeaderRaw:String = "
    #pragma version
    #pragma precision
    attribute float openfl_Alpha;
    attribute vec4 openfl_ColorMultiplier;
    attribute vec4 openfl_ColorOffset;
    attribute vec4 openfl_Position;
    attribute vec2 openfl_TextureCoord;
    varying float openfl_Alphav;
    varying vec4 openfl_ColorMultiplierv;
    varying vec4 openfl_ColorOffsetv;
    varying vec2 openfl_TextureCoordv;
    uniform mat4 openfl_Matrix;
    uniform bool openfl_HasColorTransform;
    uniform vec2 openfl_TextureSize;
";
	static final glVertexBodyRaw:String = "
    openfl_Alphav = openfl_Alpha;
    openfl_TextureCoordv = openfl_TextureCoord;
    if (openfl_HasColorTransform) {
        openfl_ColorMultiplierv = openfl_ColorMultiplier;
        openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
    }
    gl_Position = openfl_Matrix * openfl_Position;
";

	static final glFragmentBodyRaw:String = "
		vec4 color = texture2D (bitmap, openfl_TextureCoordv);
		if (color.a == 0.0) {
			gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
		} else if (openfl_HasColorTransform) {
			color = vec4 (color.rgb / color.a, color.a);
			mat4 colorMultiplier = mat4 (0);
			colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
			colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
			colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
			colorMultiplier[3][3] = 1.0; // openfl_ColorMultiplierv.w;
			color = clamp (openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
			if (color.a > 0.0) {
				gl_FragColor = vec4 (color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
			} else {
				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);
			}
		} else {
			gl_FragColor = color * openfl_Alphav;
		}
	";

	/**
	 * Constructs a GLSL shader.
	 * @param fragmentSource The fragment shader source.
	 * @param vertexSource The vertex shader source.
	 * Note you also need to `initialize()` the shader MANUALLY! It can't be done automatically.
	 */
	public function new(fragmentSource:String = null, vertexSource:String = null, glslVersion:Int = 120):Void
	{
		this.glVersion = glslVersion;

		if (fragmentSource == null)
		{
			// See: https://jobf.github.io/flixel-shadertoy-shader/ (First shader)
			this.glFragmentSource = __processFragmentSource("
            void mainImage( out vec4 fragColor, in vec2 fragCoord )
            {
                vec2 uv = fragCoord/iResolution.xy;
                vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4)); 
                fragColor = vec4(col,1.0);
            }  
        ");
		}
		else
		{
			this.glFragmentSource = __processFragmentSource(fragmentSource);
		}

		if (vertexSource == null)
		{
			// See: https://jobf.github.io/flixel-shadertoy-shader/ (First shader)
			var s = __processVertexSource("
            void mainImage( out vec4 fragColor, in vec2 fragCoord )
            {
                vec2 uv = fragCoord/iResolution.xy;
                vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
                fragColor = vec4(col,1.0);
            }
            ");
			this.glVertexSource = s;
		}
		else
		{
			var s = __processVertexSource(vertexSource);
			this.glVertexSource = s;
		}

		@:privateAccess {
			// This tells the shader that the glVertexSource/glFragmentSource have been updated.
			this.__glSourceDirty = true;
		}

		super();
	}

	/**
	 * Replace the `#pragma header` and `#pragma body` with the fragment shader header and body.
	 */
	@:noCompletion private function __processFragmentSource(input:String):String
	{
		var result = StringTools.replace(input, PRAGMA_HEADER, glFragmentHeaderRaw);
		result = StringTools.replace(result, PRAGMA_BODY, glFragmentBodyRaw);
		return result;
	}

	/**
	 * Replace the `#pragma header` and `#pragma body` with the vertex shader header and body.
	 */
	@:noCompletion private function __processVertexSource(input:String):String
	{
		var result = StringTools.replace(input, PRAGMA_HEADER, glVertexHeaderRaw);
		result = StringTools.replace(result, PRAGMA_BODY, glVertexBodyRaw);
		return result;
	}

	/**
	 * Modify a float parameter of the shader.
	 *
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setFloat(name:String, value:Float):Void
	{
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);
		@:privateAccess
		if (prop == null)
		{
			trace('[WARN] Shader float property ${name} not found.');
			return;
		}
		prop.value = [value];
	}

	/**
	 * Modify a float array parameter of the shader.
	 *
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setFloatArray(name:String, value:Array<Float>):Void
	{
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader float[] property ${name} not found.');
			return;
		}
		prop.value = value;
	}

	/**
	 * Modify an integer parameter of the shader.
	 *
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setInt(name:String, value:Int):Void
	{
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader int property ${name} not found.');
			return;
		}
		prop.value = [value];
	}

	/**
	 * Modify an integer array parameter of the shader.
	 *
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setIntArray(name:String, value:Array<Int>):Void
	{
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader int[] property ${name} not found.');
			return;
		}
		prop.value = value;
	}

	/**
	 * Modify a boolean parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setBool(name:String, value:Bool):Void
	{
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader bool property ${name} not found.');
			return;
		}
		prop.value = [value];
	}

	/**
	 * Modify a boolean array parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setBoolArray(name:String, value:Array<Bool>):Void
	{
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader bool[] property ${name} not found.');
			return;
		}
		prop.value = value;
	}

	/**
	 * Modify a bitmap data parameter of the shader.
	 * @param name The name of the parameter to modify.
	 * @param value The new value to use.
	 */
	public function setBitmapData(name:String, value:openfl.display.BitmapData):Void
	{
		var prop:ShaderInput<openfl.display.BitmapData> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader sampler2D property ${name} not found.');
			return;
		}
		prop.input = value;
	}

	/**
	 * Retrieve a float parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getFloat(name:String):Null<Float>
	{
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);
		if (prop == null || prop.value.length == 0)
		{
			trace('[WARN] Shader float property ${name} not found.');
			return null;
		}
		return prop.value[0];
	}

	/**
	 * Retrieve a float array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getFloatArray(name:String):Null<Array<Float>>
	{
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader float[] property ${name} not found.');
			return null;
		}
		return prop.value;
	}

	/**
	 * Retrieve an integer parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getInt(name:String):Null<Int>
	{
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);
		if (prop == null || prop.value.length == 0)
		{
			trace('[WARN] Shader int property ${name} not found.');
			return null;
		}
		return prop.value[0];
	}

	/**
	 * Retrieve an integer array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getIntArray(name:String):Null<Array<Int>>
	{
		var prop:ShaderParameter<Int> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader int[] property ${name} not found.');
			return null;
		}
		return prop.value;
	}

	/**
	 * Retrieve a boolean parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getBool(name:String):Null<Bool>
	{
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);
		if (prop == null || prop.value.length == 0)
		{
			trace('[WARN] Shader bool property ${name} not found.');
			return null;
		}
		return prop.value[0];
	}

	/**
	 * Retrieve a boolean array parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getBoolArray(name:String):Null<Array<Bool>>
	{
		var prop:ShaderParameter<Bool> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader bool[] property ${name} not found.');
			return null;
		}
		return prop.value;
	}

	/**
	 * Retrieve a bitmap data parameter of the shader.
	 * @param name The name of the parameter to retrieve.
	 * @return The value of the parameter.
	 */
	public function getBitmapData(name:String):Null<openfl.display.BitmapData>
	{
		var prop:ShaderInput<openfl.display.BitmapData> = Reflect.field(this.data, name);
		if (prop == null)
		{
			trace('[WARN] Shader sampler2D property ${name} not found.');
			return null;
		}
		return prop.input;
	}

	public function toString():String
	{
		return 'FlxRuntimeShader';
	}
}
