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

package xa 
{
	import flash.filesystem.File;
	
	import xa.filters.IFilter;
	import xa.filters.ExtensionFilter;
	
	public class Folder 
	{
		public static function create(path : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			file.createDirectory();
			file = null;
		}
		
		public static function remove(path : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			file.deleteDirectory(false);
			file = null;
		}
		
		public static function forceRemove(path : String) : void
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			file.deleteDirectory(true);
			file = null;
		}
		
		public static function read(path : String) : Vector.<String>
		{
			var ret : Vector.<String> = new Vector.<String>();
			
			var folder : flash.filesystem.File = new flash.filesystem.File(path);
			
			var files : Array = folder.getDirectoryListing();
			
			for each(var file : flash.filesystem.File in files)
			{
				ret.push(file.name);
			}
			
			return ret;
		}
		
		public static function getTotalItems(path : String) : uint
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			
			var total : uint = file.getDirectoryListing().length;
			
			file = null;
			return total;
		}
		
		public static function isEmpty(path : String) : Boolean
		{
			return (0 == getTotalItems(path));
		}
		
		public static function isFolder(path : String) : Boolean
		{
			var file : flash.filesystem.File = new flash.filesystem.File(path);
			var ret : Boolean = (file.exists && file.isDirectory);
			
			file = null;
			
			return ret;
		}
		
		public static function copy(sourcePath : String, destinationPath : String, filter : IFilter = null, deep : int = -1) : void
		{
			privateCopy(sourcePath, destinationPath, filter, deep, 0);
		}
		
		public static function copyByExtension(source : String, destination : String, extensions : Vector.<String>, copy : Boolean, deep : int = -1) : void
		{
			var filter : ExtensionFilter = new ExtensionFilter(extensions, copy);
			privateCopy(source, destination, filter, deep, 0);
		}
		
		private static function privateCopy(source : String, destination : String, filter : IFilter = null, deep : int = -1, currentLevel : int = 0) : void
		{
			var separator : String = xa.System.getSeparator();
			
			create(destination);
			
			if(filter == null)
			{
				filter = xa.Filter.All;
			}
		
			var items : Vector.<String> = read(source);
			
			for each(var itemName : String in items)
			{
				var itemPath : String = source + separator + itemName;
				
				if(filter.filter(itemPath))
				{
					if(isFolder(itemPath))
					{
						if(deep == -1)
						{
							// Full recursion, so just go ahead
							privateCopy(itemPath, destination + separator + itemName, filter, deep);
						} 
						else
						{
							// Max recursion defined, so check out currentLevel
							if(currentLevel <= deep)
							{
								currentLevel++;
								privateCopy(itemPath, destination + separator + itemName, filter, deep, currentLevel);
							}
						}
					}
					else
					{
						xa.File.copy(itemPath, destination + separator + itemName);
					}
				}
			}	
		}
	}
}