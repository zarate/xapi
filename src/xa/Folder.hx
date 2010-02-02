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

package xa;

class Folder
{
	
	public static function read(path : String) : Array<String>
	{
		return neko.FileSystem.readDirectory(path);
	}
	
	public static function create(path : String) : Void 
	{
		neko.FileSystem.createDirectory(path);
	}
	
	public static function delete(path : String) : Void 
	{
		neko.FileSystem.deleteDirectory(path);
	}
	
	public static function copy(source : String, destination : String, ?filter : String -> Bool, ?deep : Int = -1) : Void 
	{
		// We use an internal privateCopy function to keep copy public signature clean (without currentLevel counter)
		privateCopy(source, destination, filter, deep, 0);
	}
	
	public static function isFolder(path : String) : Bool 
	{
		return (neko.FileSystem.exists(path) && neko.FileSystem.isDirectory(path));
	}
	
	public static function getTotalItems(path : String) : Int
	{
		return read(path).length;
	}
	
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