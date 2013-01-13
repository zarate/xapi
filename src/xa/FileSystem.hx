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
* <p>The FileSystem class offers basic funcionality for both files and folders, including path formatting.</p>
**/

package xa;

class FileSystem
{
	/**
	* <p>Translates a path to the current OS.</p>
	**/
	public static function pathToCurrent(path : String) : String
	{
		return (xa.System.isWindows())? pathToWindows(path) : pathToUnix(path);
	}
	
	/**
	* <p>Translates a path to Unix.</p>
	**/
	public static function pathToUnix(path : String) : String
	{
		return path.split("\\").join(xa.System.UNIX_SEPARATOR);
	}
	
	/**
	* <p>Translates a path to Windows.</p>
	**/
	public static function pathToWindows(path : String) : String
	{
		return path.split("/").join(xa.System.WIN_SEPARATOR);
	}
	
	/**
	* <p>Returns true if the given path exists on the file system, false otherwise.</p>
	**/
	public static function exists(path : String) : Bool
	{
		#if flash

			var item = new flash.filesystem.File(path);
			return item.exists;

		#else

			return sys.FileSystem.exists(path);

		#end
	}
	
	/**
	* <p>Returns the size in bytes of the item. If it is a folder, it includes all its items.</p>
	**/
	public static function size(path : String) : Int
	{
		var totalBytes = 0;

		if(xa.File.isFile(path))
		{
			totalBytes = getItemSize(path);
		}
		else
		{	
			var items = xa.Search.search(path);
			
			for(item in items)
			{
				totalBytes += getItemSize(path);
			}
		}

		return totalBytes;
	}

	/**
	* <p>Renames a file or folder to a new path. <strong>Please note that you must provide a new path (either absolute or relative), not only the new desired name</strong>.</p>
	* <p>Example: if you want to rename "a.txt" to "b.txt", you can use:</p>
	* <p>[xa.FileSystem.rename("a.txt", "b.txt");]</p>
	**/
	public static function rename(path : String, newPath : String) : Void 
	{
		#if flash

			var file = new flash.filesystem.File(path);
			
			var newFile = new flash.filesystem.File(newPath);
			file.moveTo(newFile, false); // TODO: check out if haxe overwrites by default an update docs

		#else

			sys.FileSystem.rename(path, newPath);

		#end
	}

	/**
	* <p>Returns true if a file or folder is hidden, false otherwise.</p>
	* <p>In Mac and Linux, all files/folders starting with "." are considered hidden. Please note that in OSX there are
	*  other methods to hide files and folders, see <a href="http://www.westwind.com/reference/OS-X/invisibles.html">Mac OS X Hidden Files and Directories</a> for more info.</p> 
	* <p>In Windows, we use the <a href="http://www.computerhope.com/attribhl.htm">attrib command</a>, so the process might be fairly slow.</p>
	* <p>Ideally, <a href="http://haxe.org/api/sys/filestat">sys.io.FileStat</a> would return whether an item is hidden or not in a crossplatform 
	* and native manner, but until then, this is our best bet. If you can come up with faster and more reliable ways of finding out, please let us know!</p>
	**/
	public static function isHidden(path : String) : Bool
	{
		#if flash

			var file = new flash.filesystem.File(path);
			return file.isHidden;

		#else

			var hidden : Bool;
			
			if(xa.System.isUnix())
			{
				var name = xa.FileSystem.getNameFromPath(path);
				hidden = StringTools.startsWith(name, ".");
				
			}
			else
			{
				var p = new xa.Process('attrib', [path]);

				// We need to clean up the output removing the path and empty spaces.
				// Sadly, this only makes things slower :|
				
				var output = StringTools.trim(p.getOutput());
				output = output.substr(0, output.length - sys.FileSystem.fullPath(path).length);
				
				hidden = (output.indexOf('H') != -1);
			}
			
			return hidden;

		#end
	}
	
	/**
	* <p>Given the path to an item, it returns its name, <strong>including the extension (if any)</strong>.</p> 
	**/
	public static function getNameFromPath(path : String) : String
	{
		var path = new haxe.io.Path(path);
		return (null == path.ext)? path.file : path.file + "." + path.ext;
	}

	static function getItemSize(path) : Int
	{
		#if flash

			var item = new flash.filesystem.File(path);
			return Std.int(item.size);

		#else

			return sys.FileSystem.stat(path).size;

		#end
	}
}