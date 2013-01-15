/*
 * Generate haxelib:
 * http://haxe.org/doc/haxelib/using_haxelib 
 */

class Main
{	
	var _tmpFolder : String;
	
	var _version : String; 
	
	var _sourceFolder : String;
	
	var _tmpOutputFolder : String;
	
	var _outputFolder : String;

	var _commit : String;
	
	var _branch : String;

	static var TEMPLATES_FOLDER_PATH : String = "templates";
	
	static var HAXELIB_DESCRIPTOR_TEMPLATE_PATH : String = TEMPLATES_FOLDER_PATH + xa.System.getSeparator() + "haxelib.xml";
	
	static var XAPI_SRC_PATH : String = "/src";
	
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
		generateHaxelibPackage();
		generateSwc();
		
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
				
				case "-c", "-commit":
					_commit = args[x+1];

				case "-b", "-branch":
					_branch = args[x+1];

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
		
		if(null == _branch)
		{
			_branch = "master";
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
		log("Cloning remote repository: " + XAPI_REPO_URL + " (" + _branch + ")");
		
		var clone = new xa.Process("git", ["clone", "-b", _branch, XAPI_REPO_URL, _sourceFolder]);
		
		if(!clone.success())
		{
			log("ERROR while cloning the remote repository");
			exit(clone.getError());
		}
		
		// to checkout a particular tag or commit we need to set the 
		// current working directory in the source folder
		// we bring it back to the current one when we are done
		var cwd = Sys.getCwd();
		Sys.setCwd(_sourceFolder);
		
		var checkoutNode = (null == _commit)? _version : _commit;

		var checkout = new xa.Process("git", ["checkout", checkoutNode]);
		
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
		
		var docsFolder = _sourceFolder + xa.System.getSeparator() + "docs";
		
		// pick haxedoc.xml from docs folder
		var haxeDocPath = docsFolder + xa.System.getSeparator() + "haxedoc.xml";
		xa.FileSystem.rename(haxeDocPath, _tmpOutputFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(haxeDocPath));
		
		// add the docs
		xa.Folder.copy(docsFolder, _tmpOutputFolder + xa.System.getSeparator() + xa.FileSystem.getNameFromPath(docsFolder));
		
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
	}
	
	function generateSwc() : Void
	{
		// SWC generation as defined here: http://haxe.org/manual/swc

		log("Generating SWC file");

		var args = [];

		args.push("-cp");
		args.push(_sourceFolder + XAPI_SRC_PATH);
		args.push("-lib");
		args.push("air3");
		args.push("-swf");
		args.push("xapi-" + _version + ".swc");
		args.push("-swf-version");
		args.push("11");
		args.push("--macro");
		args.push("include('xa')");

		var haxe = new xa.Process("haxe", args);

		if(!haxe.success())
		{
			log("ERROR during SWC creation");
			exit(haxe.getError());
		}

		xa.Folder.forceRemove(_tmpFolder);
	}

	function printHelp() : Void
	{
		var help = [];
		
		help.push("Usage:");
		help.push("\t-v: version to be generated, ie: 0.4, 1.2, etc. Used by default as the tag name");
		help.push("\t    to checkout the repo at. See -c to specify a particular commit");
		help.push("\t-o: output folder. Optional, defaults to current working directory");
		help.push("\t-c: commit used to generate the release (HEAD and other GIT tricks work too).");
		help.push("\t    Optional, by default the tag specified in -v will be used");
		help.push("\t-b: branch. Optional, defaults to master");
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