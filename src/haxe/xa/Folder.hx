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

import xa.Backend;
import xa.filters.IFilter;

class Folder
{

	/**
	* <p>Reads the contents of the given folder returning an array of strings with the paths to the items contained.</p> 
	* <p>Please note that [xa.Folder.read()] is NOT recursive, it returns items on the given folder only. If you need to
	*  read recursively, you can use [xa.Search.search()].</p>
	**/
	
	public static function read(path : String) : Array<String>
	{
		return XAFileSystem.readDirectory(path);
	}
	
	/**
	* <p>Creates a folder in the given path.</p> 
	**/
	
	public static function create(path : String) : Void 
	{
		XAFileSystem.createDirectory(path);
	}
	
	public static function delete(path : String) : Void 
	{
		// DEPRECATED. Please use remove instead.
		remove(path);
	}
	
	/**
	* <p>Removes the folder in the given path. <strong>The folder cannot be removed if it's not empty</strong> (an exception is thrown).</p> 
	**/
	
	public static function remove(path : String) : Void 
	{
		XAFileSystem.deleteDirectory(path);
	}
	
	public static function forceDelete(path : String) : Void
	{
		// DEPRECATED. Please use forceRemove instead.
		forceRemove(path);
	}
	
	/**
	*  <p>Removes a folder <strong>WITHOUT ANY WARNINGS OR CONFIRMATIONS, even if it has content on it</strong>. USE WITH CARE!.</p>
	*  <p>In Mac and Linux uses [rm -rf path] and in Windows [RMDIR path /s /q]</p>
	**/
	
	public static function forceRemove(path : String) : Void
	{
		if(xa.System.isWindows())
		{
			var exit = XASys.command('RMDIR', [path, '/s', '/q']);
		}
		else
		{
			var p = new xa.Process('rm', ['-rf', path]);
			var exit = p.exitCode();
		}
	}
	
	/**
	* <p>Copies the contents of source folder to destination folder. <strong>Destination folder must not exist</strong>. By default all items (including hidden files and folders) are copied and the process is fully recursive.</p>
	* <p>If you want to exclude items from being copied, pass a filter function matching the String -> Bool signature. 
	* The filter function will get called once per item, receiving the path (of each item, that is).
	* It should return true if the item has to be copied, false otherwise. You can use the predefined filters in the Filter class or roll your own.</p>
	* <p>The copy is fully recursive by default (deep = -1). To copy <strong>only</strong> the items in the root of the source folder, pass 0 for the deep parameter.
	* If you want to copy items in the root and the next level, pass 1. To copy items in root + first and second levels, past 2, etc.</p> 
	**/
	
	public static function copy(sourcePath : String, destinationPath : String, ?filter : IFilter, ?deep : Int = -1) : Void 
	{
		// We use an internal privateCopy function to keep copy public signature clean (without currentLevel counter)
		privateCopy(sourcePath, destinationPath, filter, deep, 0);
	}

	/**
	*  <p>Copies source folder to destination filtering files by extension.</p>
	*  <p>Pass an array of extensions and whether files matching those extensions should be copied (true) or excluded (false).</p>
	*  <p>If you want to <strong>only</strong> copy .txt files from the source folder:</p> 
	*  <p>[xa.Folder.copyByExtension(source, destination, [".txt"], true);]</p>
	*  <p>If you want to copy al files <strong>but</strong> .swf and .project files:</p>
	*  <p>[xa.Folder.copyByExtension(source, destination, [".swf", ".project"], false);]</p>
	*  <p>Extensions are case-insensitve (would match .txt or .TXT).</p>
	*  <p>Remember that you can always roll your own filter if you have more specific needs.</p>
	**/

	public static function copyByExtension(source : String, destination : String, extensions : Array<String>, copy : Bool, ?deep : Int = -1) : Void
	{
		var filter = new xa.filters.ExtensionFilter(extensions, copy);
		privateCopy(source, destination, filter, deep, 0);
	}
	
	/**
	* <p>Returns true if the path exists and is a folder, false otherwise.</p>
	**/
	
	public static function isFolder(path : String) : Bool 
	{
		return (XAFileSystem.exists(path) && XAFileSystem.isDirectory(path));
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
	
	private static function privateCopy(source : String, destination : String, ?filter : IFilter, ?deep : Int = -1, ?currentLevel : Int = 0) : Void
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
			
			if(filter.filter(itemPath))
			{
				if(isFolder(itemPath))
				{
					if(deep == -1)
					{
						// Full recursion, so just go ahead
						privateCopy(itemPath, destination + "/" + itemName, filter, deep);
					} 
					else 
					{
						// Max recursion defined, so check out currentLevel
						if(currentLevel <= deep)
						{
							currentLevel++;
							privateCopy(itemPath, destination + "/" + itemName, filter, deep, currentLevel);
						}
					}
				} 
				else 
				{	
					xa.File.copy(itemPath, destination + "/" + itemName);	
				}
			}
		}	
	}
}