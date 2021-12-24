package modloader;

#if polymod
import polymod.Polymod;

class PolymodHandler
{
    public static var metadataArrays:Array<String> = [];

    public static function loadMods()
    {
        loadModMetadata();

		Polymod.init({
			modRoot:"mods/ModLoader/",
			dirs: ModList.getActiveMods(metadataArrays),
			errorCallback: function(error:PolymodError)
			{
				trace(error.message);
			},
            frameworkParams: {
                assetLibraryPaths: [
                    "songs" => "songs"
                ]
            }
		});
    }

    public static function loadModMetadata()
        {
            metadataArrays = [];
    
            var tempArray = Polymod.scan("mods/ModLoader/","*.*.*",function(error:PolymodError) {
                trace(error.message);
            });
    
                         for(metadata in tempArray)
                         {
                             metadataArrays.push(metadata.id);
                             ModList.modMetadatas.set(metadata.id, metadata);
                         }
}
}
#end