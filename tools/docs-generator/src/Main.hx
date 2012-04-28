/**
 * Runs through the SRC folder and generates the appropriate
 * documentation. We usually do this in preparation to an
 * upcoming release.
 *
 * Generate haxedoc:
 * http://haxe.org/doc/haxedoc?lang=en
 * 
 */

class Main
{	
	var _tmpFolder : String;
	
	var _haxedocXmlPath : String;
	
	var _docsFolder : String;
	
	var _version : String;
	
	static var XAPI_SRC_PATH : String = "../../src/haxe";
	
	static var XAPI_HAXEDOC_TEMPLATE_FILENAME : String = "template.xml";
	
	static var XAPI_HAXEDOC_TEMPLATE_PATH : String = "templates" + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME;
	
	function new()
	{
		parseArguments();
		createTmpFolder();
		generateHaxedocXml();
		generateDocs();
		udpateDocs();
		removeTmpFolder();
		
		log("REMEMBER TO COMMIT THE CHANGES TO THE REPO!!");
	}
	
	function parseArguments() : Void
	{
		var args = xa.Application.getArguments();
		
		for(x in 0...args.length)
		{
			var arg = args[x];
			
			switch(arg)
			{
				case "-v":
					_version = args[x+1];
				
				case "-h", "-help":
					printHelp();
					exit();
			}
		}
		
		if(null == _version)
		{
			log("ERROR: Cannot find version to generate");
			printHelp();
			exit();
		}
		
		log("About to generate docs for version " + _version);
	}
	
	function createTmpFolder() : Void
	{
		_tmpFolder = xa.System.getTempFolder() + xa.System.getSeparator() + "xapi-docs-" + Std.random(10000);
		
		if(xa.Folder.isFolder(_tmpFolder))
		{
			xa.Folder.forceRemove(_tmpFolder);
		}
		
		xa.Folder.create(_tmpFolder);
	}
	
	function generateHaxedocXml() : Void
	{
		log("Generating haxedoc.xml");
		
		// start by generating a class with a reference to
		// all the classes in the main XAPI package
		var allClassesFilename = "All.hx";
		
		var allClassesContent = [];
		allClassesContent.push("class All");
		allClassesContent.push("{");
		
		var classes = xa.Search.search(XAPI_SRC_PATH);
		
		for(x in 0...classes.length)
		{
			if(!xa.File.isFile(classes[x])) // ignore folders
			{
				continue;
			}
			
			var className = classes[x].substr((XAPI_SRC_PATH).length + 1);
			className = className.substr(0, className.lastIndexOf("."));
			className = StringTools.replace(className, "/", ".");
			
			allClassesContent.push("\tvar instance_" + x + " : " + className + ";");
		}
		
		allClassesContent.push("}");
		
		var allClassesPath = _tmpFolder + xa.System.getSeparator() + allClassesFilename;
		xa.File.write(allClassesPath, allClassesContent.join("\n"));
		
		// now let's create the XML required by haxedoc
		_haxedocXmlPath = _tmpFolder + xa.System.getSeparator() + "haxedoc.xml";
		var allBinaryPath = _tmpFolder + xa.System.getSeparator() + "all.n";
		
		var args = 
		[
			"-xml",
			_haxedocXmlPath,
			allClassesFilename,
			"-neko", // we pass neko here because otherwise the haxe compiler complains, and rightly so since XAPI uses Neko APIs
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
		log("Generating docs");
		
		// to generate the documentation we pass the haxedoc.xml file generated
		// before to the haxedoc tool.
		// we also pass our own template for a simpler output
		
		_docsFolder = _tmpFolder + xa.System.getSeparator() + "docs";
		xa.Folder.create(_docsFolder);
		
		var docTemplateOutputPath = _docsFolder + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME;
		
		// we need to first copy the template to the docs folder 
		// since despite what the documentation says haxedoc only looks in CWD for it
		xa.File.copy(XAPI_HAXEDOC_TEMPLATE_PATH, docTemplateOutputPath);
		
		// add version number to the docs template
		var docsTemplate = new haxe.Template(xa.File.read(docTemplateOutputPath));
		xa.File.write(docTemplateOutputPath, docsTemplate.execute({version: _version}));
		
		// copy over haxedoc.xml
		xa.File.copy(_haxedocXmlPath, _docsFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(_haxedocXmlPath));
		
		// then call haxedoc, filtering everything but the xa.* package
		var args = 
		[
			xa.FileSystem.getNameFromPath(_haxedocXmlPath),
			"-f",
			"xa"
		];
		
		// we change CWD here because haxedocs doesn't 
		// support an output folder, it simply spits out in CWD
		var currentCwd = Sys.getCwd();
		Sys.setCwd(_docsFolder);
		
		var haxedoc = new xa.Process("haxedoc", args);
		
		if(!haxedoc.success())
		{
			log("ERROR while generating haxedoc");
			exit(haxedoc.getError());
		}
		
		Sys.setCwd(currentCwd);
		
		xa.File.remove(docTemplateOutputPath);
		xa.File.remove(_docsFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(_haxedocXmlPath));
	}	
	
	function udpateDocs() : Void
	{
		log("Updating old docs folder");
		
		xa.Folder.forceRemove("../../docs");
		xa.Folder.copy(_docsFolder, "../../docs");
		xa.File.copy(_haxedocXmlPath, "../../docs/" + xa.FileSystem.getNameFromPath(_haxedocXmlPath));
	}
	
	function removeTmpFolder() : Void
	{
		xa.Folder.forceRemove(_tmpFolder);
	}
	
	function printHelp() : Void
	{
		var help = [];
		
		help.push("XAPI docs generator. Usage:");
		help.push("\t-v: version to be generated, ie: 0.4, 1.2, etc");
		help.push("\t-h -help: print this help");
		
		log(help.join("\n"));
	}
	
	function exit(?txt : String) : Void
	{
		if(null != txt)
		{
			log(txt);
		}
		
		xa.Application.exit(1);
	}
	
	function log(txt : String) : Void
	{
		xa.Utils.print(txt);
	}
	
	public static function main()
	{
		new Main();
	}
}
