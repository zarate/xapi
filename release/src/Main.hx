/*
 * Generate haxedoc:
 * http://haxe.org/doc/haxedoc?lang=en
 * 
 * Generate haxelib:
 * http://haxe.org/doc/haxelib/using_haxelib
 * 
 */

class Main
{	
	var _tmpFolder : String;
	
	var _haxedocXmlPath : String;
	
	var _version : String; 
	
	var _docsFolder : String;
	
	var _sourceFolder : String;
	
	var _tmpOutputFolder : String;
	
	var _outputFolder : String;
	
	static var TEMPLATES_FOLDER_PATH : String = "templates";
	
	static var HAXELIB_DESCRIPTOR_TEMPLATE_PATH : String = TEMPLATES_FOLDER_PATH + xa.System.getSeparator() + "haxelib.xml";
	
	static var XAPI_HAXEDOC_TEMPLATE_FILENAME : String = "template.xml";
	
	static var XAPI_HAXEDOC_TEMPLATE_PATH : String = TEMPLATES_FOLDER_PATH + xa.System.getSeparator() + XAPI_HAXEDOC_TEMPLATE_FILENAME;
	
	static var XAPI_SRC_PATH : String = "/src/haxe";
	
	static var XAPI_README_FILENAME : String = "README";
	
	static var XAPI_REPO_URL : String = "git@github.com:zarate/xapi.git";
	
	public function new()
	{
		var now = Date.now();
		
		log("XAPI release generator");
		
		parseArguments();
		createFolders();
		checkoutSource();
		copySourceCode();
		generateHaxelibXml();
		generateHaxedocXml();
		generateDocs();
		generateHaxelibPackage();
		
		log("All done (" + ((Date.now().getTime() - now.getTime()) / 1000) + "s)");
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
				
				case "-o":
					_outputFolder = args[x+1];
				
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
		
		if(null == _outputFolder)
		{
			_outputFolder = Sys.getCwd();
		}
		
		if(!xa.Folder.isFolder(_outputFolder))
		{
			log("ERROR: output folder is not valid: " + _outputFolder);
			printHelp();
			exit();
		}
		
		log("About to generate release " + _version);
	}
	
	function createFolders() : Void
	{
		_tmpFolder = xa.System.getTempFolder() + xa.System.getSeparator() + "xapi-tmp-" + _version;
		
		log("Working here: " + _tmpFolder);
		
		if(xa.Folder.isFolder(_tmpFolder))
		{
			xa.Folder.forceRemove(_tmpFolder);
		}
		
		xa.Folder.create(_tmpFolder);
		
		_tmpOutputFolder = _tmpFolder + xa.System.getSeparator() + "xapi-" + _version;
		_sourceFolder = _tmpFolder + xa.System.getSeparator() + "source";
	}
	
	function checkoutSource() : Void
	{
		log("Cloning remote repository: " + XAPI_REPO_URL);
		
		var clone = new xa.Process("git", ["clone", XAPI_REPO_URL, _sourceFolder]);
		
		if(!clone.success())
		{
			log("ERROR while cloning the remote repository");
			exit(clone.getError());
		}
		
		// to checkout the tag we need to set the 
		// current working directory in the source folder
		// we bring it back to the current one when we are done
		var cwd = Sys.getCwd();
		Sys.setCwd(_sourceFolder);
		
		var checkout = new xa.Process("git", ["checkout", _version]);
		
		if(!checkout.success())
		{
			log("ERROR while checking out tag: " + _version);
			exit(checkout.getError());
		}
		
		Sys.setCwd(cwd);
	}
	
	function copySourceCode() : Void
	{
		log("Copying source code");
		xa.Folder.copy(_sourceFolder + XAPI_SRC_PATH, _tmpOutputFolder);
	}
	
	function generateHaxelibXml() : Void
	{
		log("Generating haxelib.xml");
		
		var descriptorTemplate = new haxe.Template(xa.File.read(HAXELIB_DESCRIPTOR_TEMPLATE_PATH));
		xa.File.write(_tmpOutputFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(HAXELIB_DESCRIPTOR_TEMPLATE_PATH), descriptorTemplate.execute({version: _version}));
	}
	
	function generateHaxedocXml() : Void
	{
		log("Generating haxedoc.xml");
		
		var classes = xa.Search.search(_sourceFolder + XAPI_SRC_PATH);		
		
		// start by generating a class with a reference to
		// all the classes in the main XAPI package
		var allClassesFilename = "All.hx";
		var allClassesPath = _sourceFolder + XAPI_SRC_PATH + xa.System.getSeparator() + allClassesFilename;
		
		var allClassesContent = [];
		allClassesContent.push("class All");
		allClassesContent.push("{");
		
		for(x in 0...classes.length)
		{
			if(!xa.File.isFile(classes[x])) // ignore folders
			{
				continue;
			}
			
			var className = classes[x].substr((_sourceFolder + XAPI_SRC_PATH).length + 1);
			className = className.substr(0, className.lastIndexOf("."));
			className = StringTools.replace(className, "/", ".");
			
			allClassesContent.push("\tvar instance_" + x + " : " + className + ";");
		}
		
		allClassesContent.push("}");
		
		xa.File.write(allClassesPath, allClassesContent.join("\n"));
		
		// now let's create the XML required by haxedoc
		_haxedocXmlPath = _tmpOutputFolder + xa.System.getSeparator() + "haxedoc.xml";
		var allBinaryPath = _tmpFolder + xa.System.getSeparator() + "all.n";
		
		var args = 
		[
			"-xml",
			_haxedocXmlPath,
			allClassesFilename,
			"-neko", // we pass neko here because otherwise the haxe compiler complains, and rightly so since XAPI uses Neko APIs
			allBinaryPath,
			"-cp",
			_sourceFolder + XAPI_SRC_PATH
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
	
	function generateHaxelibPackage() : Void
	{
		log("Generating ZIP file");
		
		// the haxelib package it's a zip with this structure:
		// * xapi-version
		// 		** haxelib.xml 
		//		** haxedoc.xml // <-- so we get docs displayed in lib.haxe.org
		//		** README // <-- bit of info and point people to project's site
		//		** docs // <-- in case someone is off-line
		//		** xa // <-- source code's structure ready to be used
		//			*** Application.hx
		//			*** File.hx
		//			*** ...
		
		var outputFolderName = xa.FileSystem.getNameFromPath(_tmpOutputFolder);
		var outputHaxelibZipName = xa.FileSystem.getNameFromPath(_tmpOutputFolder) + ".zip";
		
		// add the README
		xa.File.copy(_sourceFolder + xa.System.getSeparator() + XAPI_README_FILENAME, _tmpOutputFolder + xa.System.getSeparator() + XAPI_README_FILENAME);
		
		// add the docs
		xa.Folder.copy(_docsFolder, _tmpOutputFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(_docsFolder));
		
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
		
		// WE ARE GOOD TO GO!!
		// move the zip to the output folder
		
		var finalZipPath = _outputFolder + xa.FileSystem.getNameFromPath(outputHaxelibZipPath);		
		
		if(xa.File.isFile(finalZipPath))
		{
			xa.File.remove(finalZipPath);
		}
		
		xa.File.copy(outputHaxelibZipPath, finalZipPath);
		
		log(_version + " ZIP ready: " + finalZipPath);
		
		xa.Folder.forceDelete(_tmpFolder);
	}
	
	function printHelp() : Void
	{
		var help = [];
		
		help.push("Usage:");
		help.push("\t-v: version to be generated, ie: 0.4, 1.2, etc");
		help.push("\t-o: output folder. Optional, defaults to current working directory");
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