package states.menus.modloader;

// this is here so the game doesnt crash because of no framework params
#if (MODS && polymod)
import polymod.Polymod;

class PolymodHandler
{
	public static var swagMeta:String;
	public static var metadataArrays:Array<String> = [];

	public static function loadMods()
	{
		loadModMetadata();

		Polymod.init({
			modRoot: "mods/",
			dirs: ModList.getActiveMods(metadataArrays),
			errorCallback: function(error:PolymodError)
			{
				// trace(error.message);
			},
			frameworkParams: {
				assetLibraryPaths: ["songs" => "songs", "shared" => "shared", "fonts" => "fonts"]
			}
		});
	}

	public static function loadModMetadata()
	{
		metadataArrays = [];

		var tempArray = Polymod.scan("mods/", "*.*.*", function(error:PolymodError)
		{
			trace(error.message);
		});

		for (metadata in tempArray)
		{
			swagMeta = metadata.id;
			metadataArrays.push(metadata.id);
			ModList.modMetadatas.set(metadata.id, metadata);
		}
	}
}
#end
