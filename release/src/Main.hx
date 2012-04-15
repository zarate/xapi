/*
 * Generate haxedoc:
 * http://haxe.org/doc/haxedoc?lang=en
 * 
 * Generate haxelib:
 * http://haxe.org/doc/haxelib/using_haxelib
 * 
 * TODO:
 * 		add version to docs
 * 		add output as parameter to output the final zip wherever
 */

class Main
{	
	var _tmpFolder : String;
	
	var _haxedocXmlPath : String;
	
	var _version : String; 
	
	var _docsFolder : String;
	
	static var TEMPLATES_FOLDER_PATH : String = "templates";
	
	static var HAXELIB_DESCRIPTOR_FILENAME : String = "haxelib.xml";
	
	static var HAXELIB_DESCRIPTOR_TEMPLATE_PATH : String = TEMPLATES_FOLDER_PATH + xa.System.getSeparator() + HAXELIB_DESCRIPTOR_FILENAME;
	
	static var XAPI_HAXEDOC_TEMPLATE_FILENAME : String = "template.xml";
	
	static var XAPI_HAXEDOC_TEMPLATE_PATH : String = TEMPLATES_FOLDER_PATH + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME;
	
	static var XAPI_SRC_PATH : String = "../src/haxe";
	
	static var XAPI_README_PATH : String = "../README";
	
	public function new()
	{
		log("XAPI release generator");
		
		parseArguments();
		generateTempFolder();
		generateOutputXml();
		generateDocs();
		generateHaxelibPackage();
		
		log("All done");
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
			}
		}
		
		if(null == _version)
		{
			log("ERROR: Cannot find version to generate");
			printHelp();
			exit();
		}
		
		log("About to generate release " + _version);
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
		
		// start by generating a class with a reference to
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
		_docsFolder = _tmpFolder + xa.System.getSeparator() + "docs";
		xa.Folder.create(_docsFolder);
		
		// we need to copy the template first
		// to the docs folder since despite what the documentation says
		// haxedoc only looks in CWD for the file
		xa.File.copy(XAPI_HAXEDOC_TEMPLATE_PATH, _docsFolder + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME);
		
		// then call haxedoc, filtering everything but the xa.* package
		var args = 
		[
			"../" + xa.FileSystem.getNameFromPath(_haxedocXmlPath),
			"-f",
			"xa"
		];
		
		// we change CWD here because haxedocs doesn't 
		// support an output folder, it simply spits out
		// in CWD
		var currentCwd = Sys.getCwd();
		Sys.setCwd(_docsFolder);
		
		var haxedoc = new xa.Process("haxedoc", args);
		
		if(!haxedoc.success())
		{
			log("ERROR while generating haxedoc");
			exit(haxedoc.getError());
		}
		
		Sys.setCwd(currentCwd);
		
		// we have the docs now, we can remove the template.
		xa.File.remove(_docsFolder + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME);
	}
	
	function generateHaxelibPackage() : Void
	{
		// the haxelib package it's a zip with this structure
		// * xapi-version
		// 		** haxelib.xml 
		//		** haxedoc.xml // <-- so we get docs displayed in lib.haxe.com
		//		** README // <-- bit of info and point people to project's site
		//		** docs // <-- in case someone is off-line
		//		** xa
		//			*** Application.hx
		//			*** File.hx
		//			*** ...
		
		var outputFolderName = "xapi-" + _version;
		var outputHaxelibZipName = "xapi-" + _version + ".zip";
		
		// folder to drop all the haxelib goodies
		var outputFolderPath = _tmpFolder + xa.System.getSeparator() + outputFolderName;

		// copy the actual source code
		xa.Folder.copy(XAPI_SRC_PATH, outputFolderPath);
		
		// add haxelib descriptor xml from the template
		var descriptorTemplate = new haxe.Template(xa.File.read(HAXELIB_DESCRIPTOR_TEMPLATE_PATH));
		xa.File.write(outputFolderPath + xa.System.getSeparator() + HAXELIB_DESCRIPTOR_FILENAME, descriptorTemplate.execute({version: _version}));
		
		// add haxedoc.xml 
		xa.File.copy(_haxedocXmlPath, outputFolderPath + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(_haxedocXmlPath));
		
		// add the README
		xa.File.copy(XAPI_README_PATH, outputFolderPath + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(XAPI_README_PATH));
		
		// add the docs
		xa.Folder.copy(_docsFolder, outputFolderPath + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(_docsFolder));
		
		// now zip it
		
		// we can't change the root folder zip uses,
		// so we need to change the current working directory
		// and then comeback to the current one after zip is done
		
		var currentCwd = Sys.getCwd();
		Sys.setCwd(_tmpFolder);
		
		var args = 
		[
			"-r",
			outputHaxelibZipName,
			outputFolderName
		];
		
		var zip = new xa.Process("zip", args);
		
		if(!zip.success())
		{
			log("ERROR: Cannot zip for haxelib");
			exit(zip.getError());
		}
		
		// back to the wordking directory
		Sys.setCwd(currentCwd);
		
		// now test it on haxelib
		var outputHaxelibZipPath = _tmpFolder + xa.System.getSeparator() + outputHaxelibZipName;
		
		var haxelibArgs = 
		[
			"test",
			outputHaxelibZipPath
		];
		
		var haxelib = new xa.Process("haxelib", haxelibArgs);
		
		if(!haxelib.success())
		{
			log("ERROR: we don't pass haxelib validation");
			exit(haxelib.getError());
		}
	}
	
	function printHelp() : Void
	{
		var help = [];
		
		help.push("Usage:");
		help.push("\t-v: version to be generated, ie: 0.4, 1.2, etc");
		help.push("\t-h -help: print this help");
		
		log(help.join("\n"));
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