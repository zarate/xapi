/*
MIT license:
http://www.opensource.org/licenses/mit-license.php

Copyright (c) 2010 XAPI project contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

/**
* <p>The Folder class offers functionality to work with folders in the system.</p> 
**/

package xa;

class Folder
{

	/**
	* <p>Reads the contents of the given folder returning an array of strings with the paths to the items it contains.</p> 
	**/
	
	public static function read(path : String) : Array<String>
	{
		return neko.FileSystem.readDirectory(path);
	}
	
	/**
	* <p>Creates a folder in the given path.</p> 
	**/
	
	public static function create(path : String) : Void 
	{
		neko.FileSystem.createDirectory(path);
	}
	
	/**
	* <p>Deletes the folder in the given path. <strong>The folder cannot be deleted if it's not empty.</strong></p> 
	**/
	
	public static function delete(path : String) : Void 
	{
		neko.FileSystem.deleteDirectory(path);
	}
	
	/**
	* <p>Copies the contents of source folder to destination folder. <strong>Destination folder must not exist</strong>. By default all items (including hidden files and folders) are copied and the process is fully recursive.</p>
	* <p>If you want to exclude items from being copied, pass a filter function matching the String -> Bool signature. 
	* The filter function will get called once per item, receiving the path (of each item, that is).
	* It should return true if the item has to be copied, false otherwise.</p>
	* <p>The copy is fully recursive by default. To copy <strong>only</strong> the items in the root of the source folder, pass 0 for the deep parameter.
	* If you want to copy items in the root and the next level, pass 1. To copy items in root + first and second levels, past 2, etc.</p> 
	**/
	
	public static function copy(sourcePath : String, destinationPath : String, ?filter : String -> Bool, ?deep : Int = -1) : Void 
	{
		// We use an internal privateCopy function to keep copy public signature clean (without currentLevel counter)
		privateCopy(sourcePath, destinationPath, filter, deep, 0);
	}

	/**
	*  <p>Copies source folder to destination filtering by extension.</p>
	*  <p>Pass an array of extensions and whether files matching those extensions should be included (true) or excluded(false).</p>
	*  <p>If you want to <strong>only</strong> copy .txt files from the source folder, you could do: xa.Folder.copyByExtension(source, destination, [".txt"], true).</p>
	*  <p>If you want to copy every item <strong>but</strong> .swf and .project files, you could do: xa.Folder.copyByExtension(source, destination, [".swf", ".project"], false).</p>
	*  <p>Extensions are case-insensitve (would match .txt or .TXT).</p>
	*  <p>Remeber that you can always roll your own filtering function if you have more specific needs.</p>
	**/

	public static function copyByExtension(source : String, destination : String, extensions : Array<String>, include : Bool, ?deep : Int = -1) : Void
	{
		
		_extensions = extensions;
		_include = include;
		
		privateCopy(source, destination, extensionFilter, deep, 0);
		
	}
	
	/**
	* <p>Returns true if the path exists and is a folder, false otherwise.</p>
	**/
	
	public static function isFolder(path : String) : Bool 
	{
		
		var exists : Bool = false;
		
		if(path != null)
		{
			exists = (neko.FileSystem.exists(path) && neko.FileSystem.isDirectory(path));
		}
		
		return exists;
	}
	
	/**
	* <p>Returns the number of items in the given folder.</p>
	**/
	
	public static function getTotalItems(path : String) : Int
	{
		return read(path).length;
	}
	
	/**
	* <p>Returns true if the folder has no items.</p>
	**/
	
	public static function isEmpty(path : String) : Bool 
	{
		return (getTotalItems(path) == 0);
	}
	
	// ---------------------------- 
	
	private static function privateCopy(source : String, destination : String, ?filter : String -> Bool, ?deep : Int = -1, ?currentLevel : Int = 0) : Void
	{
		
		if(isFolder(source))
		{
			
			if(!xa.FileSystem.exists(destination))
			{
				
				create(destination);
				
				if(filter == null)
				{
					filter = xa.Filter.ALL;
				}
			
				var items = read(source);
				
				for(itemName in items)
				{
					
					var itemPath = source + "/" + itemName;
					
					if(filter(itemPath))
					{
						
						if(isFolder(itemPath))
						{
							
							if(deep == -1)
							{
								
								// Full recursion, so just go ahead
								privateCopy(itemPath, destination + "/" + itemName, filter, deep);
								
							} else {
								
								// Max recursion defined, so check out currentLevel
								if(currentLevel <= deep)
								{
									
									currentLevel++;
									privateCopy(itemPath, destination + "/" + itemName, filter, deep, currentLevel);
									
								}
								
							}
							
						} else {
							
							xa.File.copy(itemPath, destination + "/" + itemName);
							
						}
						
					}
					
				}			
				
			} else {
				
				throw "Destination folder (" + destination + ") already exists";
				
			}
			
		} else {
			
			throw "Source folder (" + source + ") is not a directory or it doesn't exist";
			
		}
		
	}
	
	private static function extensionFilter(path : String) : Bool
	{
		
		var copy = false;
		
		if(xa.File.isFile(path))
		{
			
			var hasExtension = xa.File.hasExtension(path, _extensions);
			copy = (_include)? hasExtension : !hasExtension;
			
		}
		else
		{
			copy = true;
		}
		
		return copy;		
	}
	
	private static var _extensions : Array<String>;
	
	private static var _include : Bool;
	
}