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
* <p>The Folder class offers functionality to work with folders in your system.</p> 
**/

package xa;

class Folder
{

	/**
	* <p>Reads the contents of a given folder returning an array strings with the paths to the items contained.</p> 
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
	* <p>Deletes the folder in the given path.</p> 
	**/
	
	public static function delete(path : String) : Void 
	{
		neko.FileSystem.deleteDirectory(path);
	}
	
	/**
	* <p>Copies the contents of source folder to destination folder. <strong>Destination folder must not exist</strong>. By default all items are copied and the process is fully recursive.</p>
	* <p>If you want to exclude items from being copied, pass a filter function matching the String -> Bool signature. 
	* The filter function will get called for each item, passing to it
	* the path to each item. It should return true if the item has to be copied, false otherwise.</p>
	* <p>The copy is fully recursive by default. To copy <strong>only</strong> the items in the root of the source folder, pass 0 for the deep parameter.
	* If you want to copy items in the root and the next level, pass 1. To copy items in root + first and second levels, past 2, etc.</p> 
	**/
	
	public static function copy(source : String, destination : String, ?filter : String -> Bool, ?deep : Int = -1) : Void 
	{
		// We use an internal privateCopy function to keep copy public signature clean (without currentLevel counter)
		privateCopy(source, destination, filter, deep, 0);
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
	
}