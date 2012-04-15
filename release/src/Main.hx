/*

Generate haxedoc:
http://haxe.org/doc/haxedoc?lang=en

Generate haxelib:
http://haxe.org/doc/haxelib/using_haxelib


*/

class Main
{	
	var _tmpFolder : String;
	
	var _haxedocXmlPath : String;
	
	static var XAPI_HAXEDOC_TEMPLATE_FILENAME : String = "template.xml";
	
	static var XAPI_HAXEDOC_TEMPLATE_PATH : String = "templates" + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME;
	
	static var XAPI_SRC_PATH : String = "../src/haxe";
	
	public function new()
	{
		log("XAPI release generator");
		
		generateTempFolder();
		generateOutputXml();
		generateDocs();
		
		// TODO: generate haxelib valid zip package
		// TODO: add xapi version to zip and docs
		
		log("All done");
	}
	
	function generateTempFolder() : Void
	{
		// FIXME: use folder from tmp, delete when done
		_tmpFolder = "bin/tmp";
		
		if(xa.Folder.isFolder(_tmpFolder))
		{
			xa.Folder.forceRemove(_tmpFolder);
		}
		
		xa.Folder.create(_tmpFolder);
	}
	
	function generateOutputXml() : Void
	{
		var classes = xa.Search.search(XAPI_SRC_PATH);		
		
		// start by generating a class with a reference with
		// all the classes in the main XAPI package
		var allClassesFilename = "All.hx";
		var allClassesPath = _tmpFolder + xa.System.getSeparator() + allClassesFilename;
		
		var allClassesContent = [];
		allClassesContent.push("class All");
		allClassesContent.push("{");
		
		for(x in 0...classes.length)
		{
			if(!xa.File.isFile(classes[x])) // ignore folders
			{
				continue;
			}
			
			var className = classes[x].substr(XAPI_SRC_PATH.length + 1);
			className = className.substr(0, className.lastIndexOf("."));
			className = StringTools.replace(className, "/", ".");
			
			allClassesContent.push("\tvar instance_" + x + " : " + className + ";");
		}
		
		allClassesContent.push("}");
		
		xa.File.write(allClassesPath, allClassesContent.join("\n"));
		
		
		// now let's create the XML required by haxedoc
		_haxedocXmlPath = _tmpFolder + xa.System.getSeparator() + "haxedoc.xml";
		var allBinaryPath = _tmpFolder + xa.System.getSeparator() + "all.n";
		
		var args = 
		[
			"-xml",
			_haxedocXmlPath,
			allClassesFilename,
			"-neko",
			allBinaryPath,
			"-cp",
			XAPI_SRC_PATH,
			"-cp",
			_tmpFolder
		];
		
		var haxe = new xa.Process("haxe", args);
		
		if(!haxe.success())
		{
			log("ERROR while generating haxedoc.xml");
			exit(haxe.getError());
		}
	}
	
	function generateDocs() : Void
	{
		// we need to copy the template first
		xa.File.copy(XAPI_HAXEDOC_TEMPLATE_PATH, _tmpFolder + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME);
		
		// then call haxedoc, filtering everything but the xa.* package
		var args = 
		[
			_haxedocXmlPath,
			"-f",
			"xa"
		];
		
		var haxedoc = new xa.Process("haxedoc", args);
		
		if(!haxedoc.success())
		{
			log("ERROR while generating haxedoc");
			exit(haxedoc.getError());
		}
	}
	
	public static function exit(?txt : String) : Void
	{
		if(null != txt)
		{
			log(txt);
		}
		
		xa.Application.exit(1);
	}
	
	public static function log(txt : String) : Void
	{
		xa.Utils.print(txt);
	}
	
	public static function main()
	{
		new Main();
	}
}